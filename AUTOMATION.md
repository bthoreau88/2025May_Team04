# Skill Automation — What's wired, and why

This is the "why" behind the automation. For each skill we lock in, this file gives the
**scenario** (when it should fire), **why it's suggested**, the **benefit**, and **how it's wired**.
It ends with why the rest of the directory is deliberately *not* automated.

Automation here is **repo config only** — two low-friction mechanisms, nothing runs on a schedule
or touches your account:

1. **`CLAUDE.md` rules** — declarative "invoke skill X when Y" directives Claude reads every session
   (works on any OS, local or in a cloud Routine, because a fresh clone always loads `CLAUDE.md`).
2. **`.claude/settings.json` SessionStart hook** — prints `.claude/skill-policy.md` into context at
   the start of every session, so the policy is present even before the model reads `CLAUDE.md`.

The `CLAUDE.md` rule is the load-bearing mechanism; the hook is reinforcement.

---

## The most-useful-to-automate set

We automate three skills. The test for "worth automating" is simple: **does it apply on almost
every session of a given kind, and is forgetting it costly?** These three pass; most skills don't.

### 1. `session-handoff` — always-on wrap-up

- **Scenario.** Any time a session is ending or context is filling up — you say "wrap up",
  "hand off", "let's clear", or you're about to `/clear`.
- **Why suggested.** Long sessions fill context; the course's entire token/context module is about
  *not* burning tokens re-deriving state you already had. A handoff is the cheap insurance that
  makes a `/clear` safe.
- **Benefit.** Zero lost state between sessions — decisions, key files, running processes,
  verification steps, and open questions survive the context reset. The next agent (or you tomorrow)
  picks up from the summary instead of re-exploring the repo. Directly lowers token cost per task.
- **How it's wired.** `CLAUDE.md` rule: *before `/clear` or on any wrap-up/hand-off request, invoke
  `session-handoff` and produce the chat-only handoff.* The skill is chat-only by design, so nothing
  gets written to disk — it just guarantees the summary happens.

### 2. `grill-me` — front-load requirements on any non-trivial task

- **Scenario.** The start of any planning/design/build task that isn't a one-liner — a new feature,
  a design brief, an architecture decision, or when you say "plan / design / brainstorm / grill me".
- **Why suggested.** Most rework comes from starting to build before the requirements are actually
  pinned. `grill-me` forces the decision tree to be walked *first*, and — crucially — checkpoints
  every answer to a durable `brainstorms/` file so nothing is lost as context grows.
- **Benefit.** Fewer misunderstandings and less rework; a durable capture file that survives context
  loss and doubles as the brief for the eventual implementation. Pairs naturally with plan mode.
- **How it's wired.** `CLAUDE.md` rule: *before starting a non-trivial plan/design/feature, invoke
  `grill-me` to interview and capture, unless the user says to skip it.* Explicit escape hatch so it
  never blocks trivial edits.

### 3. `frontend-design` — before any UI code (web context only)

- **Scenario.** Before writing or reshaping any frontend/UI code in this repo.
- **Why suggested.** Un-guided AI UI clusters around a few templated looks. This skill forces a
  deliberate palette/type/layout/motion decision per brief. This repo is a web/design context, so
  the rule applies here (it is intentionally **not** wired in the Android app repo).
- **Benefit.** Distinctive, non-templated UI, applied consistently — the same guarantee the course's
  Web Design `CLAUDE.md` gives ("invoke `frontend-design` before any frontend code, no exceptions").
- **How it's wired.** `CLAUDE.md` rule mirroring the course pattern: *invoke `frontend-design` before
  writing any frontend code, every session, no exceptions.*

---

## Deliberately NOT automated (documented, on-demand)

The rest of the directory — **Marketing, Social Media, Finance, Small Business, Legal**, and most of
the external Developer/Designer skills — is cataloged but **not** auto-wired. That's a choice, not an
omission:

- **They're context-specific.** You reach for a legal contract-review skill or a Reels-thumbnail
  skill for a *specific* task, not on every session. Auto-invoking them would be noise, and noise
  trains you to ignore the automation that matters.
- **They're external and unverified here.** They install from third-party repos/plugins we can't
  vet in this environment. Auto-wiring an unverified skill is a supply-chain risk; cataloging it with
  its link lets you install deliberately from a source you trust.
- **Some need human sign-off** (Legal especially). On-demand keeps a human in the loop.

**Rule of thumb:** automate the skill that applies to *almost every* session of a kind and is costly
to forget (handoff, requirements, UI craft). Catalog everything else and invoke it by name.

---

## Graduating to cloud Routines (opt-in)

Everything above runs *inside a session you start*. To run work **autonomously** — nightly, on a PR,
or from an API call — promote it to a **Claude Code Routine** (cloud). Because a Routine clones this
repo fresh, it inherits this `CLAUDE.md` and therefore these same auto-invocation rules for free. See
[directory/operations-automation.md](directory/operations-automation.md) and
[docs/claude-code-routines-reference.md](docs/claude-code-routines-reference.md). No Routines have
been created for you — that step changes account state and uses a daily run cap, so it's yours to
opt into.

---

## Adapting this

- **Turn a rule off:** delete or edit the line in [`CLAUDE.md`](CLAUDE.md).
- **Change what SessionStart shows:** edit [`.claude/skill-policy.md`](.claude/skill-policy.md).
- **On Windows without git-bash:** the hook uses `cat`; if your shell lacks it, change `cat` to
  `type` in `.claude/settings.json`. The `CLAUDE.md` rules keep working regardless — they don't
  depend on the hook.
