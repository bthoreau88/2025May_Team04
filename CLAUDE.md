# CLAUDE.md — Skill Automation Rules

This repo auto-invokes a small set of installed skills (in `.claude/skills/`). The reasoning behind
each rule is in [`AUTOMATION.md`](AUTOMATION.md). Follow these every session.

## Auto-invoke rules

1. **Requirements first — `grill-me`.** Before starting any non-trivial plan, design, or feature,
   invoke the `grill-me` skill to interview the user and checkpoint answers to a `brainstorms/` file.
   Skip only for trivial edits, or if the user explicitly says to skip it.

2. **UI craft — `frontend-design`.** Invoke the `frontend-design` skill **before writing any
   frontend/UI code, every session, no exceptions.** Derive palette, typography, layout, and motion
   deliberately; avoid templated AI defaults.

3. **Wrap-up — `session-handoff`.** Before the user runs `/clear`, or whenever they ask to "wrap up",
   "hand off", or "summarize before clearing", invoke the `session-handoff` skill and produce the
   chat-only handoff. Proactively offer it when context is getting large.

## Notes

- These rules are read on every fresh clone, so they also apply inside cloud **Routines**.
- The `.claude/settings.json` SessionStart hook prints `.claude/skill-policy.md` as a reminder of
  the above at session start.
- To change automation behavior, edit these rules or see [`AUTOMATION.md`](AUTOMATION.md).
