# Claude, Inc. — A Company of Skills

A company-style **directory** of Claude skills, organized like an org chart. Each department
below is a page listing its skills, what they do, and where to install them. Some skills are
**included in this repo** (`.claude/skills/`) and wired to run automatically — see
[`AUTOMATION.md`](AUTOMATION.md). The rest are external installs, cataloged here with their links.

> Inspired by the *"Someone turned Claude into an entire company"* thread and assembled together
> with the resources from the **Claude Code Course 2026**.

## The org chart

| Department | What it covers | Page |
|---|---|---|
| 🛠️ **Developers** | Coding superpowers, docs lookup, skill/MCP authoring, testing, memory | [directory/developers.md](directory/developers.md) |
| 🎨 **Designers** | Visual identity, UI/UX, motion, brand, artifacts | [directory/designers.md](directory/designers.md) |
| 📣 **Marketing** | Copywriting, SEO, lead magnets (45-skill pack) | [directory/marketing.md](directory/marketing.md) |
| 📱 **Social Media** | Posts, Reels, thumbnails (17-skill pack) | [directory/social-media.md](directory/social-media.md) |
| 💰 **Finance** | Statements, reconciliation, audits (plugin) | [directory/finance.md](directory/finance.md) |
| 🏪 **Small Business** | Cash flow, payroll, invoicing (plugin) | [directory/small-business.md](directory/small-business.md) |
| ⚖️ **Legal** | Contract review, NDAs, compliance (plugin) | [directory/legal.md](directory/legal.md) |
| ⚙️ **Operations & Automation** | Routines, context/token management, dashboards | [directory/operations-automation.md](directory/operations-automation.md) |

## What's actually in this repo

```
.claude/skills/          # real skill files, installed and auto-wired
  session-handoff/       # end-of-session context handoff  (Developers / Ops)
  grill-me/              # relentless requirements interview (Developers / Ops)
  frontend-design/       # distinctive UI design guidance    (Designers)
.claude/settings.json    # SessionStart hook that surfaces the auto-skill policy
.claude/skill-policy.md  # the policy the hook prints into every session
CLAUDE.md                # auto-invocation rules Claude reads every session
AUTOMATION.md            # per-skill: when to use it, why, the benefit, how it's wired
directory/               # the department catalog pages
docs/                    # Claude Code Routines reference (cloud automation)
```

## How to use this

- **Browsing for a skill?** Open the department page and follow the install link.
- **Want a skill to run automatically?** The three in `.claude/skills/` already do — the rules
  live in `CLAUDE.md` and the rationale is in [`AUTOMATION.md`](AUTOMATION.md).
- **Want autonomous, scheduled runs?** See [Operations & Automation](directory/operations-automation.md)
  for Claude Code **Routines** (cloud, opt-in).

## A note on the links

External links are transcribed from the source thread. A few were truncated there and are marked
**(verify link)** — expand/confirm the repo before installing anything you don't recognize. Only
install skills from sources you trust.

## Provenance

The three bundled skills and the Routines reference come from the **Claude Code Course 2026**
resource pack (`session-handoff`, `grill-me`, and Anthropic's `frontend-design` skill, plus the
cloud-automation reference). They are copied verbatim, frontmatter intact.
