# config

个人跨机器的 shell / 终端 / 编辑器 / pi 配置。  
目标不是做一个通用 dotfiles 框架，而是让三件事变简单：

- **初始化**：换一台机器时，知道该拿哪些文件、放到哪里。
- **维护**：知道一个改动应该落在哪个文件，不会把 macOS 和 WSL 的配置混在一起。
- **被理解**：新人或 agent 读完这一页，就能知道仓库里每个东西大致是干什么的。

细节、协议和实现原因看文件里的注释，尤其是 `shared/pi/agent/extensions/wt-tabs.ts`。  
给 coding agent 的约定见 [AGENTS.md](AGENTS.md)。

## 目录结构

```text
.
├── README.md
├── AGENTS.md
├── shared/
│   ├── .vimrc
│   └── pi/agent/extensions/wt-tabs.ts
├── macos/
│   ├── .bash_profile
│   ├── .zshrc
│   └── alacritty.toml
├── wsl/
│   ├── .bashrc
│   ├── .tmux.conf
│   └── config.fish
├── windows/
│   └── README.md
└── scripts/
    ├── bootstrap.sh
    └── bootstrap.ps1
```

根目录保留了一组**兼容软链**，让旧的 `~/.tmux.conf -> ~/config/.tmux.conf`、`~/.pi -> ~/config/.pi` 继续可用：

```text
.bash_profile -> macos/.bash_profile
.zshrc        -> macos/.zshrc
alacritty.toml-> macos/alacritty.toml
.bashrc       -> wsl/.bashrc
.tmux.conf    -> wsl/.tmux.conf
config.fish   -> wsl/config.fish
.vimrc        -> shared/.vimrc
.pi           -> shared/pi
```

新机器不需要依赖这些根软链，直接用 `scripts/bootstrap.sh` 链接平台目录即可。

## 平台

| 平台 | 文件 | 说明 |
|---|---|---|
| macOS | `macos/.bash_profile`、`macos/.zshrc`、`macos/alacritty.toml` | 历史配置，路径里有 `/opt/homebrew`、`/Users/syh` |
| WSL / Ubuntu | `wsl/.bashrc`、`wsl/.tmux.conf`、`wsl/config.fish` | 当前主要使用环境 |
| WSL / Windows Terminal | `shared/pi/agent/extensions/wt-tabs.ts` | pi 扩展，跨 WSL/tmux 和原生 Windows |
| Windows | `windows/README.md` | Windows Terminal 设置说明；扩展来自 `shared/pi` |
| 跨平台 | `shared/.vimrc` | Vim 通用配置 |

> 仓库不是完整的 dotfiles 安装器。`wsl/config.fish`、`wsl/.bashrc`、`shared/.vimrc` 和线上文件仍可能有 drift；覆盖前先 `diff`。

## 初始化

### macOS / WSL

先 dry-run，确认会改哪些文件：

```bash
./scripts/bootstrap.sh --dry-run
```

实际执行：

```bash
./scripts/bootstrap.sh --apply
```

默认用软链；想用拷贝：

```bash
./scripts/bootstrap.sh --apply --copy
```

脚本会：

- 自动判断 macOS / Linux（Linux 按 WSL 处理；可用 `--platform macos|wsl` 覆盖）
- 备份已有目标为 `<target>.bak-YYYYMMDD-HHMMSS`
- 创建缺失的目录
- 打印需要重载的程序

### Windows

```powershell
# 只打印
pwsh -File .\scripts\bootstrap.ps1

# 复制 pi 扩展
pwsh -File .\scripts\bootstrap.ps1 -Apply
```

Windows Terminal 的 `settings.json` **不会**被自动修改；合并说明见 [windows/README.md](windows/README.md)。

### 重载

```bash
source ~/.bashrc        # bash
tmux source-file ~/.tmux.conf
exec fish               # fish
# pi 里执行 /reload
```

## 文件地图

| 文件 | 作用 |
|---|---|
| `wsl/.bashrc` | WSL/Ubuntu bash：alias、PATH、nvm、conda 等 |
| `macos/.bash_profile` | macOS 登录 shell，当前 WSL 不用 |
| `macos/.zshrc` | macOS zsh，当前 WSL 不用 |
| `shared/.vimrc` | Vim 基础配置 |
| `wsl/config.fish` | WSL fish prompt、alias、环境变量；仍有历史 macOS 片段 |
| `macos/alacritty.toml` | Alacritty 主题和字体，macOS/Linux 用，WT 不用 |
| `wsl/.tmux.conf` | tmux 主配置：前缀、窗口、copy mode、状态栏、pi 集成 |
| `shared/pi/agent/extensions/wt-tabs.ts` | pi 扩展：窗口名/标签名、进度圈、完成通知 |
| `windows/README.md` | WT 设置合并说明 |
| `scripts/bootstrap.sh` | macOS/WSL 初始化脚本 |
| `scripts/bootstrap.ps1` | Windows pi 扩展部署脚本 |

## pi 扩展

`wt-tabs.ts` 做三件事：

1. 把当前 pi 会话名或第一句话写进 **WT 标签标题** 或 **tmux 窗口名**。
2. 运行时显示进度圈，完成时发 Windows toast。
3. 用标记表达状态：

```text
● 任务名      运行中
任务名 ✓      已完成
任务名 ✗      已中止
```

环境适配：

| 环境 | 完成事件 | 标题载体 | 进度圈 | 通知 |
|---|---|---|---|---|
| 原生 Windows + WT | `agent_settled` | WT tab title | OSC 9;4 直发 | Windows toast |
| WSL + tmux + WT | `agent_end` | tmux window name | tmux passthrough | 通过 `powershell.exe` 弹 toast |
| 其他/SSH | 不启用 | — | — | — |

约定：

- 只在 `WT_SESSION` 存在时启用；SSH 里不会乱弹通知。
- WSL 下会关闭该 tmux 窗口的 `automatic-rename`，否则名字会被改回 `pi`。
- 进度圈依赖 tmux 的 `allow-passthrough on`；`wsl/.tmux.conf` 已配置。
- 不会自动移动 tab/window。WT 没有这个 API；需要时用 `Ctrl+Shift+Left/Right` 手动挪。
- 完成通知和 tmux 的 activity 监控是两回事。不要用 `monitor-activity` 做“完成”提示，它会对任何后台输出亮灯/响铃。

## tmux

当前约定（`wsl/.tmux.conf`）：

- Prefix：`Ctrl+\`
- 窗口从 1 开始编号
- `Alt+1..9` 直接切窗口
- copy mode 使用 vi 键位
- 状态栏显示 `#I #W`，pi 窗口名自带 `●/✓`
- `set-titles-string '#S / #W'`：WT 标签标题跟随 tmux 当前窗口

已知缺口：

- `prefix + R/C/|/-` 依赖 `tmux-commands`，`prefix + S` 依赖 `tmux-sessions`，`prefix + P` 依赖 `~/.dotfiles/...`；这些 helper 目前不在仓库/PATH 里。
- TPM 插件（resurrect、continuum）需要另外安装；仓库只保存配置，不保存 `~/.tmux/plugins`。
- `~/.tmux.conf.local` 是机器本地文件，不在仓库；它通常放 TPM、resurrect、continuum 配置。

## 扩展新配置

新增一个工具的配置时：

1. 判断平台：`shared/`、`macos/`、`wsl/`、`windows/`。
2. 放进去，文件名尽量保持工具默认路径。
3. 更新本 README 的文件地图和部署说明。
4. 更新 `scripts/bootstrap.sh` / `bootstrap.ps1` 的部署列表。
5. 做最小验证：
   - bash：`bash -n`
   - fish：`fish -n`
   - tmux：`tmux source-file ~/.tmux.conf`
   - pi 扩展：`bun build ... --external '@earendil-works/pi-coding-agent'`，然后在新的 pi 会话里 `/reload`
6. 用中文短标题提交，一个提交只做一件事。

## 安全

不要提交：

- `~/.pi/agent/auth.json`
- `~/.pi/agent/sessions/`
- `~/.tmux.conf.local` 里的机器私有路径/密钥
- 任何 token、cookie、私钥、公司内网地址

如果某个配置必须包含敏感信息，放本地 `*.local` 文件，并在 README 里说明它不跟踪。
