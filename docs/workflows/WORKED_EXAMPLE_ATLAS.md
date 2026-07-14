# Worked Example — Current Project ATLAS Milestone

This example applies the OVS multi-agent workflow to a real, current milestone
in this repository **without modifying that milestone's implementation**. It
exists so every agent can see the contracts filled in with real values.

## The milestone

- **Milestone:** THESE HANDZ Godot 4 scaffold (constants, input, combat,
  characters, managers)
- **Pull request:** https://github.com/bthoreau88/2025May_Team04/pull/2
- **Implementation branch:** `claude/these-handz-godot-setup-nhu4kg`
- **Head SHA:** `f68713f77981bd7849e6c681736c60fadff3cf4b`
- **Base:** `main` at `fedf4e68649ee883cbad372109fc0912c3afd28d`

Historical note: this milestone predates the adoption of this standard, so its
branch carries a `claude/` prefix rather than `codex/`. Under the standard it
plays the role of the implementation branch. It is treated as another agent's
published work: read-only.

## Stage 1 — Implementation (done)

The scaffold exists on the branch above with its own PR into `main`. One
milestone, one branch — already compliant.

## Stage 2 — Review contract (how a review of this milestone is initiated)

```
MODE: REVIEW
SOURCE BRANCH: claude/these-handz-godot-setup-nhu4kg
SOURCE SHA: f68713f77981bd7849e6c681736c60fadff3cf4b
PR: https://github.com/bthoreau88/2025May_Team04/pull/2
ALLOWED: read, test, analyze, comment
FORBIDDEN: edit source branch, push to source branch, merge, force-push
REVIEW: acceptance criteria, regressions, missing tests, architecture, docs
OUTPUT: severity-ranked findings with exact paths and lines
```

The reviewer checks out the branch in an isolated worktree:

```bash
git fetch origin
git worktree add ../2025May_Team04-claude-review origin/claude/these-handz-godot-setup-nhu4kg
```

Findings come back as BLOCKER / HIGH / MEDIUM / LOW / NOTE with exact paths,
e.g. `GameConstants.gd:12`. Nothing on the source branch is edited.

## Stage 3 — Enhancement handoff (hypothetical, filled in for illustration)

If review found, say, missing test coverage for the parry system, the founder
or architect would issue a handoff like this before any Claude write occurs:

```
Task ID: ATLAS-HANDZ-001
Mode: ENHANCE
Source branch: claude/these-handz-godot-setup-nhu4kg
Source SHA: f68713f77981bd7849e6c681736c60fadff3cf4b
Target branch: claude/enhance-atlas-handz-001-parry-tests
Allowed paths: tests/**
Forbidden paths: GameConstants.gd, everything else
Acceptance criteria: parry window edge cases covered; existing behavior unchanged
Validation commands: godot --headless --run-tests (once a test harness exists)
```

The enhancement branch is based on the exact SHA above, and its PR targets the
implementation branch — not `main`.

## Stages 4–6 — Architecture review, founder approval, merge

ChatGPT reviews the combined PR against the ATLAS roadmap; Brandon Thoreau
Kelly approves; the PR merges into `main` via GitHub; `CHANGELOG.md` and
`ROADMAP.md` are updated and the handoff is closed.

Nothing in this example changes the scaffold itself.
