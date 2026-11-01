/**
 * Windows Terminal tab titles for pi (no multiplexer)
 *  - tab 标题 = 会话名或第一句话
 *  - ● 运行中，✓ 完成，✗ 中止
 *  - 运行时 tab 显示进度圈，完成时发 Windows toast
 * Target: pi 1.4+ on native Windows. WSL's pi 0.74.x uses different event names.
 * Install: copy to %USERPROFILE%\.pi\agent\extensions\wt-tabs.ts
 */
import { execFile } from "node:child_process";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const inWT = Boolean(process.env.WT_SESSION) && !process.env.ZELLIJ_SESSION_NAME;

function toast(title: string, body: string) {
  if (process.platform !== "win32") return;
  const t = title.replace(/'/g, "''");
  const b = body.replace(/'/g, "''");
  const type = "Windows.UI.Notifications";
  const mgr = `[${type}.ToastNotificationManager, ${type}, ContentType = WindowsRuntime]`;
  const tmpl = `[${type}.ToastTemplateType]::ToastText01`;
  const ps = [
    `${mgr} > $null`,
    `$xml = [${type}.ToastNotificationManager]::GetTemplateContent(${tmpl})`,
    `$xml.GetElementsByTagName('text')[0].AppendChild($xml.CreateTextNode('${b}')) > $null`,
    `[${type}.ToastNotificationManager]::CreateToastNotifier('${t}').Show([${type}.ToastNotification]::new($xml))`,
  ].join("; ");
  const encoded = Buffer.from(ps, "utf16le").toString("base64");
  execFile("powershell.exe", ["-NoProfile", "-EncodedCommand", encoded], { windowsHide: true }, () => {});
}

export default function (pi: ExtensionAPI) {
  if (!inWT) return;

  let base = "pi";
  let autoNamed = false;

  const title = (ctx: ExtensionContext, mark = "") => {
    ctx.ui.setTitle(`${mark}${base}`);
  };

  const progress = (on: boolean) => {
    // OSC 9;4: ConEmu/Windows Terminal 进度条
    process.stdout.write(on ? "\x1b]9;4;3;0\x07" : "\x1b]9;4;0;0\x07");
  };

  pi.on("session_start", async (_event, ctx) => {
    const dir = process.cwd().split(/[\\/]/).filter(Boolean).pop() ?? "pi";
    base = pi.getSessionName()?.trim() || dir;
    autoNamed = Boolean(pi.getSessionName());
    title(ctx);
  });

  pi.on("session_info_changed", async (event, ctx) => {
    const name = event.name?.trim();
    if (name) {
      base = name;
      autoNamed = true;
      title(ctx);
    }
  });

  pi.on("before_agent_start", async (event, ctx) => {
    const named = pi.getSessionName()?.trim();
    if (named) {
      base = named;
      autoNamed = true;
    } else if (!autoNamed && event.messageType === "user") {
      const prompt = Array.from(event.prompt.replace(/\s+/g, " ").trim()).slice(0, 20).join("");
      if (prompt) {
        base = prompt;
        autoNamed = true;
      }
    }
    title(ctx, "● ");
    progress(true);
  });

  pi.on("agent_settled", async (event, ctx) => {
    title(ctx, event.aborted ? "✗ " : "✓ ");
    progress(false);
    toast(`pi · ${base}`, event.aborted ? "已中止" : "已完成，等待输入");
  });

  pi.on("session_shutdown", async (_event, ctx) => title(ctx));
}
