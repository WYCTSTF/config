/**
 * pi tab/window status for Windows Terminal (native Windows and WSL/tmux)
 *  - 标题/窗口名 = 会话名或第一句话
 *  - ● 运行中，✓ 完成，✗ 中止
 *  - 运行时 WT 标签显示进度圈；完成发 Windows toast
 *
 * Target:
 *  - native Windows: pi 1.4+ (agent_settled)
 *  - WSL + tmux:     pi 0.7x (agent_end), 通过 tmux 窗口名 + passthrough 显示
 */
import { execFile, execFileSync } from "node:child_process";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const isWin = process.platform === "win32";
const hasWT = Boolean(process.env.WT_SESSION);
const inTmux = Boolean(process.env.TMUX && process.env.TMUX_PANE);
const inZellij = Boolean(process.env.ZELLIJ_SESSION_NAME);
const pane = process.env.TMUX_PANE;

function toast(title: string, body: string) {
  if (!hasWT) return;
  if (isWin || process.platform === "linux") {
    // On WSL this goes through Windows interop.
    const t = title.replace(/'/g, "''");
    const b = body.replace(/'/g, "''");
    const type = "Windows.UI.Notifications";
    const mgr = `[${type}.ToastNotificationManager, ${type}, ContentType = WindowsRuntime]`;
    const tmpl = `[${type}.ToastTemplateType]::ToastText01`;
    const ps = [
      `${mgr} > $null`,
      `$xml = [${type}.ToastNotificationManager]::GetTemplateContent(${tmpl})`,
      `$xml.GetElementsByTagName('text').Item(0).AppendChild($xml.CreateTextNode('${b}')) > $null`,
      `[${type}.ToastNotificationManager]::CreateToastNotifier('${t}').Show([${type}.ToastNotification]::new($xml))`,
    ].join("; ");
    const encoded = Buffer.from(ps, "utf16le").toString("base64");
    execFile("powershell.exe", ["-NoProfile", "-EncodedCommand", encoded], { windowsHide: true }, () => {});
  }
}

function tmuxRun(args: string[]) {
  execFile("tmux", args, { timeout: 3000 }, () => {});
}

function tmuxSet(args: string[]) {
  try {
    execFileSync("tmux", args, { stdio: "ignore", timeout: 3000 });
  } catch {}
}

export default function (pi: ExtensionAPI) {
  if (!hasWT || inZellij) return;

  let base = "pi";
  let autoNamed = false;

  const setTitle = (ctx: ExtensionContext, mark = "", suffix = "") => {
    const name = `${mark}${base}${suffix}`;
    if (inTmux && pane) {
      tmuxRun(["rename-window", "-t", pane, name]);
    } else {
      ctx.ui.setTitle(name);
    }
  };

  const progress = (on: boolean) => {
    const osc = on ? "\x1b]9;4;3;0\x07" : "\x1b]9;4;0;0\x07";
    if (inTmux) {
      // DCS passthrough: ESC in the payload is doubled; needs allow-passthrough on.
      process.stdout.write(`\x1bPtmux;\x1b${osc}\x1b\\`);
    } else {
      process.stdout.write(osc);
    }
  };

  const nameFromPrompt = (event: any) => {
    const named = pi.getSessionName()?.trim();
    if (named) {
      base = named;
      autoNamed = true;
      return;
    }
    const messageType = event?.messageType;
    if (!autoNamed && (!messageType || messageType === "user")) {
      const prompt = Array.from(String(event?.prompt ?? "").replace(/\s+/g, " ").trim())
        .slice(0, 20)
        .join("");
      if (prompt) {
        base = prompt;
        autoNamed = true;
      }
    }
  };

  pi.on("session_start", async (_event, ctx) => {
    const dir = process.cwd().split(/[\\/]/).filter(Boolean).pop() ?? "pi";
    base = pi.getSessionName()?.trim() || dir;
    autoNamed = Boolean(pi.getSessionName());

    if (inTmux) {
      // Keep our window name instead of tmux's automatic command name.
      if (pane) tmuxSet(["set-window-option", "-t", pane, "automatic-rename", "off"]);
      // Required for OSC 9;4 progress to reach Windows Terminal through tmux.
      tmuxSet(["set-option", "-p", "-t", pane, "allow-passthrough", "on"]);
    }
    setTitle(ctx);
  });

  pi.on("before_agent_start", async (event, ctx) => {
    nameFromPrompt(event);
    setTitle(ctx, "● ");
    progress(true);
  });

  const finish = (ctx: ExtensionContext, aborted = false) => {
    // 完成标记放在结尾；不要再用 tmux 的 activity 圆点，那个是“后台有输出”就会亮。
    setTitle(ctx, "", aborted ? " ✗" : " ✓");
    progress(false);
    toast(`pi · ${base}`, aborted ? "已中止" : "已完成，等待输入");
  };

  if (isWin) {
    // pi 1.4+: final idle after retries / compaction / queued work.
    pi.on("session_info_changed", async (event, ctx) => {
      const name = event.name?.trim();
      if (name) {
        base = name;
        autoNamed = true;
        setTitle(ctx);
      }
    });
    pi.on("agent_settled", async (event, ctx) => finish(ctx, event.aborted));
  } else {
    // pi 0.7x on WSL: no agent_settled yet.
    pi.on("agent_end", async (_event, ctx) => finish(ctx, false));
  }

  pi.on("session_shutdown", async (_event, ctx) => setTitle(ctx));
}
