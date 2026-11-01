# config

个人跨机器的 shell / 终端 / 编辑器 / pi 配置。  
目标不是做一个通用 dotfiles 框架，而是让三件事变简单：

- **初始化**：换一台机器时，知道该拿哪些文件、放到哪里。
- **维护**：知道一个改动应该落在哪个文件，不会把 macOS 和 WSL 的配置混在一起。
- **被理解**：新人或 agent 读完这一页，就能知道仓库里每个东西大致是干什么的。

细节、协议和实现原因看文件里的注释，尤其是 `.pi/agent/extensions/wt-tabs.ts`。
给 coding agent 的约定见 [AGENTS.md](AGENTS.md)。

## 平台

| 平台 | 主要文件 | 说明 |
|---|---|---|
| macOS | `.bash_profile`、`.zshrc`、`alacritty.toml` | 历史配置，路径里有 `/opt/homebrew`、`/Users/syh` |
| WSL / Ubuntu | `.bashrc`、`.tmux.conf` | 当前主要使用环境 |
| WSL / Windows Terminal | `.pi/agent/extensions/wt-tabs.ts` | pi 扩展，跨 WSL/tmux 和原生 Windows |
| 跨平台 | `.vimrc`、`config.fish` | Vim 通用；fish 里混有 macOS/WSL 片段 |
| Windows | 不在本仓库 | Windows Terminal 的 `settings.json` 和 pi 扩展是单独部署的 |

> 当前仓库不是完整的 dotfiles 安装器：`.tmux.conf` 是软链，`.pi` 扩展在 WSL 是软链；`.bashrc`、`.vimrc`、`config.fish` 更像是“存档/拷贝”，和线上文件可能有 drift。

## 快速开始

1. 先确认自己在哪个平台，**不要直接全量覆盖**。
2. 需要哪个文件就链接或拷贝哪个，覆盖前先备份；拷贝前先 `diff`，仓库里的 `.bashrc`/`.vimrc`/`config.fish` 不保证等于线上。
3. 重载对应程序：

```bash
# bash
source ~/.bashrc

# tmux
tmux source-file ~/.tmux.conf

# fish
exec fish

# pi
# 在 pi 里执行 /reload
```

### WSL 常用部署

```bash
ln -sf ~/config/.tmux.conf ~/.tmux.conf
ln -sf ~/config/.pi/agent/extensions/wt-tabs.ts ~/.pi/agent/extensions/wt-tabs.ts
```

`.tmux.conf` 会 source `~/.tmux.conf.local`；这个文件是机器本地配置，**不在仓库里**，通常放 TPM、resurrect、continuum 等插件配置。

### Windows 常用部署

把扩展复制到：

```text
%USERPROFILE%\.pi\agent\extensions\wt-tabs.ts
```

Windows Terminal 的 `settings.json` 不在本仓库；至少需要：

- `suppressApplicationTitle: false`，否则 tab 标题不会跟着 pi 走
- `Shift+Enter` 的 `sendInput` 动作，pi 才能插入换行
- 可选：`tabSwitcherMode: "mru"`，让 `Ctrl+Tab` 按最近使用顺序切换

## 文件地图

| 文件 | 作用 |
|---|---|
| `.bashrc` | WSL/Ubuntu bash 配置：alias、PATH、nvm、conda 等 |
| `.bash_profile` | macOS 登录 shell 配置，当前 WSL 不用 |
| `.zshrc` | macOS zsh 配置，当前 WSL 不用 |
| `.vimrc` | Vim 基础配置 |
| `config.fish` | fish prompt、alias、环境变量；里面有跨平台/历史片段 |
| `alacritty.toml` | Alacritty 主题和字体，macOS/Linux 用，WT 不用 |
| `.tmux.conf` | tmux 主配置：前缀、窗口、copy mode、状态栏、pi 集成 |
| `.pi/agent/extensions/wt-tabs.ts` | pi 扩展：窗口名/标签名、进度圈、完成通知 |

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

几个约定：

- 只在 `WT_SESSION` 存在时启用；SSH 里不会乱弹通知。
- WSL 下会关闭该 tmux 窗口的 `automatic-rename`，否则名字会被改回 `pi`。
- 进度圈依赖 tmux 的 `allow-passthrough on`；`.tmux.conf` 已配置。
- 不会自动移动 tab/window。WT 没有这个 API；需要时用 `Ctrl+Shift+Left/Right` 手动挪。
- 完成通知和 tmux 的 activity 监控是两回事。不要用 `monitor-activity` 做“完成”提示，它会对任何后台输出亮灯/响铃。

## tmux

当前约定：

- Prefix：`Ctrl+\`
- 窗口从 1 开始编号
- `Alt+1..9` 直接切窗口
- copy mode 使用 vi 键位
- 状态栏显示 `#I #W`，pi 窗口名自带 `●/✓`
- `set-titles-string '#S / #W'`：WT 标签标题跟随 tmux 当前窗口

已知缺口：

- `prefix + R/C/|/-` 依赖 `tmux-commands`，`prefix + S` 依赖 `tmux-sessions`，`prefix + P` 依赖 `~/.dotfiles/...`；这些 helper 目前不在仓库/PATH 里。
- TPM 插件（resurrect、continuum）需要另外安装；仓库只保存配置，不保存 `~/.tmux/plugins`。

## 扩展新配置

新增一个工具的配置时：

1. 先判断平台：shared / macOS / WSL / Windows。
2. 放进对应目录（见下面的“整理建议”），文件名尽量保持工具默认路径。
3. 更新本 README 的文件地图和部署说明。
4. 做最小验证：
   - bash：`bash -n`
   - fish：`fish -n`
   - tmux：`tmux source-file ~/.tmux.conf`
   - pi 扩展：`bun build ... --external '@earendil-works/pi-coding-agent'`，然后在新的 pi 会话里 `/reload`
5. 用中文短标题提交，一个提交只做一件事。

## 整理建议

现在的问题是**平铺 + 平台混杂**：

- macOS 文件（`.bash_profile`、`.zshrc`、`alacritty.toml`）和 WSL 文件（`.bashrc`、`.tmux.conf`）混在根目录。
- `config.fish` 同时有 macOS、WSL、Wayland 片段。
- 软链/拷贝状态不一致，新人不知道哪个是“活的”。
- 没有初始化脚本，换机器只能靠记忆。

建议逐步整理成：

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
│   ├── alacritty.toml
│   └── config.fish
├── wsl/
│   ├── .bashrc
│   ├── .tmux.conf
│   └── config.fish
├── windows/
│   └── README.md              # WT 设置说明 / pi 扩展部署
└── scripts/
    ├── bootstrap.sh           # macOS/WSL: 检测平台、备份、link/copy
    └── bootstrap.ps1          # Windows: 复制 pi 扩展
```

迁移步骤建议：

1. 先加 `bootstrap.sh --dry-run`，只打印“会改哪些文件”，不实际动。
2. 再把文件移动到平台目录，保留根目录兼容软链（例如 `.tmux.conf -> wsl/.tmux.conf`）。
3. 最后更新本 README 和 `~/.tmux.conf` 的软链目标。

在迁移完成前，**根目录布局仍然是唯一约定**；不要同时维护两套路径。

## 安全

不要提交：

- `~/.pi/agent/auth.json`
- `~/.pi/agent/sessions/`
- `~/.tmux.conf.local` 里的机器私有路径/密钥
- 任何 token、cookie、私钥、公司内网地址

如果某个配置必须包含敏感信息，放本地 `*.local` 文件，并在 README 里说明它不跟踪。
