# Windows

原生 Windows 主要涉及两件事：

1. **pi 扩展**：把 `shared/pi/agent/extensions/wt-tabs.ts` 复制到 pi 的扩展目录。
2. **Windows Terminal 设置**：标题、Shift+Enter、MRU 切换等需要手动合并；仓库不会自动改 WT 配置。

## pi 扩展

默认只打印将要做什么：

```powershell
pwsh -File .\scripts\bootstrap.ps1
```

确认后复制：

```powershell
pwsh -File .\scripts\bootstrap.ps1 -Apply
```

目标路径：

```text
%USERPROFILE%\.pi\agent\extensions\wt-tabs.ts
```

已有文件会备份为 `wt-tabs.ts.bak-YYYYMMDD-HHMMSS`。

如果 Windows 执行策略拦截脚本，用：

```powershell
pwsh -ExecutionPolicy Bypass -File .\scripts\bootstrap.ps1 -Apply
```

在已有 pi 会话里执行 `/reload`，或新开一个 pi。

## Windows Terminal

设置文件：

```text
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

### 标题

pi 用 OSC 标题序列修改 tab 标题，WT 需要允许应用改标题。PowerShell profile 里确保：

```json
"suppressApplicationTitle": false
```

如果你的 profile 没写这一项，默认就是 `false`，通常不用动。

### Shift+Enter

pi 需要 Shift+Enter 插入换行。WT 默认会把 Shift+Enter 当普通 Enter；在 `actions` 里加：

```json
{
  "command": { "action": "sendInput", "input": "\u001b[13;2u" },
  "keys": "shift+enter"
}
```

改完完全关闭 WT 再打开。

### Ctrl+Tab 按最近使用切换

在设置根节点加：

```json
"tabSwitcherMode": "mru"
```

### 手动移动标签（可选）

WT 没有“某个标签完成就自动前移”的 API；需要时用快捷键手动挪：

```json
{ "id": "Terminal.MoveTabBackward", "keys": "ctrl+shift+left" },
{ "id": "Terminal.MoveTabForward", "keys": "ctrl+shift+right" }
```

## 扩展在 Windows 上的行为

```text
● 任务名      运行中
任务名 ✓      已完成
任务名 ✗      已中止
```

- 标题：WT tab title
- 进度：OSC 9;4，WT 的 tab 进度圈
- 完成：Windows toast
- 完成事件：pi 1.4+ 的 `agent_settled`
- 不自动移动 tab

细节在 `shared/pi/agent/extensions/wt-tabs.ts` 的注释里。
