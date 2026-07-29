# 🛠️ Developers

The engineering floor: coding superpowers, live docs lookup, tooling to build your own
skills/MCP servers, automated app testing, and persistent memory.

| Skill | What it does | Install / link |
|---|---|---|
| **Superpowers** | A broad pack of developer "superpower" skills for Claude Code. | `github.com/obra/superpowers` |
| **Context7** | Pulls up-to-date, version-accurate library docs into context on demand. | `github.com/upstash/context7` |
| **Skill Creator** | Scaffolds new Claude skills (the `SKILL.md` + structure) for you. | `github.com/anthropics/skills` |
| **MCP Builder** | Helps you author MCP servers to give Claude new tools. | `github.com/anthropics/skills` |
| **Webapp Testing** | Drives a browser to test web apps end-to-end. | `github.com/anthropics/skills` |
| **Claude-Mem** | Persistent memory across sessions. | `github.com/thedotmack/claude-mem` |

## Included in this repo (auto-wired)

These two ship in `.claude/skills/` and are set to run automatically — see [`../AUTOMATION.md`](../AUTOMATION.md).

| Skill | What it does | Where |
|---|---|---|
| **grill-me** | Relentlessly interviews you about a plan/design, checkpointing every answer to a durable brainstorm file so nothing is lost. | `.claude/skills/grill-me/` |
| **session-handoff** | Produces a structured end-of-session handoff so a fresh agent can continue seamlessly after `/clear`. | `.claude/skills/session-handoff/` |

> Both also serve the **Operations** function — they're the glue that keeps long, multi-session
> work from losing context. See [operations-automation.md](operations-automation.md).
