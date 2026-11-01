# AGENTS.md

这个仓库是个人跨机器配置，不是通用 dotfiles 框架。  
改任何东西前先读 `README.md`。

## 首先确认

- 目标平台：macOS、WSL/Ubuntu、原生 Windows。
- 目标文件当前是软链还是拷贝：`.tmux.conf` 在 WSL 是软链；`.bashrc`、`.vimrc`、`config.fish` 可能只是拷贝，线上文件可能和仓库有 drift。
- 有没有机器本地文件：`~/.tmux.conf.local`、`~/.pi/agent/auth.json`、`~/.pi/agent/sessions/` 不在仓库里。

## 硬规则

- 不要提交 secrets、token、私钥、`auth.json`、session 文件、公司内网地址。
- 不要在没有备份的情况下覆盖用户线上配置。改之前先备份到 `*.bak-YYYYMMDD-HHMMSS`。
- 不要把 macOS 专用路径（`/opt/homebrew`、`/Users/...`）写进 WSL/Windows 配置。
- 不要把“后台有输出”当成“任务完成”。完成通知只应绑定 pi 的完成事件（Windows: `agent_settled`；WSL pi 0.7x: `agent_end`）。
- 改动 `.tmux.conf` 后，至少执行一次 `tmux source-file ~/.tmux.conf` 验证。
- 改动 pi 扩展后，至少做一次语法/打包检查，并在新 pi 会话里 `/reload` 验证。

## 当前布局

根目录平铺：

- `.bash_profile`、`.zshrc`、`alacritty.toml`：macOS 历史配置
- `.bashrc`：WSL bash
- `.tmux.conf`：WSL tmux + pi 集成
- `.vimrc`：跨平台 Vim
- `config.fish`：fish，历史/跨平台混合
- `.pi/agent/extensions/wt-tabs.ts`：pi 扩展

`README.md` 里有文件地图和整理建议。迁移到平台目录前，不要同时维护两套路径。

## 验证命令

```bash
bash -n .bashrc
fish -n config.fish
tmux source-file ~/.tmux.conf

bun build .pi/agent/extensions/wt-tabs.ts \
  --outfile /tmp/wt-tabs.js \
  --external '@earendil-works/pi-coding-agent'
```

pi 扩展验证：

- 新开一个 tmux 窗口跑 `pi`，确认窗口名变成会话名/目录名。
- 发一轮对话，确认运行中是 `● 任务`，结束后是 `任务 ✓`，并弹 toast。
- 切到别的 window，确认不会因为后台输出亮 activity 点或响铃。
- 需要旧会话生效时在 pi 里 `/reload`。

## 提交

- 中文短标题，例如 `tmux: 状态栏显示窗口名`。
- 一个提交只做一件逻辑改动。
- 改文件地图/部署方式时同步更新 `README.md`。
