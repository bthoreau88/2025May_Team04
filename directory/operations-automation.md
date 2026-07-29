# ⚙️ Operations & Automation

The back office: how skills get scheduled, how context/tokens are managed, and how work runs
autonomously. This is where the org "keeps the lights on."

## Skill automation in this repo

Two of the bundled skills are the operational glue for long, multi-session work:

| Skill | Operational job | Where |
|---|---|---|
| **session-handoff** | Clean context handoff so you can `/clear` and keep going without losing state. | `.claude/skills/session-handoff/` |
| **grill-me** | Front-loads requirements into a durable capture file before real work starts. | `.claude/skills/grill-me/` |

The rules that make them fire live in [`../CLAUDE.md`](../CLAUDE.md); the reasoning is in
[`../AUTOMATION.md`](../AUTOMATION.md); the SessionStart hook that surfaces them each session is
`.claude/settings.json`.

## Claude Code Routines (cloud automation — opt-in)

**Routines** are saved Claude Code tasks that run on Anthropic's cloud on a schedule, on an API
call, or on a GitHub event — even with your laptop closed. Full reference:
[`../docs/claude-code-routines-reference.md`](../docs/claude-code-routines-reference.md).

- **Three trigger types:** Schedule (cron, min 1 hour), API (POST + bearer token), GitHub (PRs, pushes, issues, releases…).
- **Each run** clones your repo fresh (so it reads this repo's `CLAUDE.md`), works in an isolated
  cloud env, pushes to a `claude/`-prefixed branch, and creates a reviewable session on claude.ai.
- **Create them at** `claude.ai/code/routines`, or `/schedule` in the CLI (scheduled only).

> This directory is **repo config only** — no live Routines have been created. Routines change
> your account state and draw down a daily run cap, so they're documented here as an opt-in step.

### Natural Routine candidates for this setup

- **On every PR:** run the `frontend-design` guardrails + a review against `CLAUDE.md` (GitHub trigger).
- **Nightly:** grooming/cleanup tasks that push fixes to a `claude/` branch (schedule trigger).
- **On demand via API:** wire an alert (Sentry/CI) to a routine that triages and opens a fix PR.

## Context & token management

From the course's token/context material — the reason `session-handoff` is worth automating:

- **Token Dashboard** (tracks local token usage): `github.com/nateherkai/token-dashboard`
- **Context Management** and **"Never Hit Your Claude Limit Again"** slide decks — large PDFs in
  the course pack; linked rather than committed to keep this repo light.

The through-line: manage context deliberately (handoffs, fresh Routine clones, tight `CLAUDE.md`)
so every session and every autonomous run starts sharp instead of bloated.
