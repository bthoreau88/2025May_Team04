# Claude Code Routines - Reference Sheet

## What It Is (One Sentence)

Routines are saved Claude Code tasks that run on Anthropic's cloud servers - on a schedule, when an API is called, or when something happens on GitHub - even when your laptop is closed.

## Status

Research preview. Behavior, limits, and API surface may change. Available on Pro, Max, Team, and Enterprise plans with Claude Code on the web enabled.

---

## How It Works

- You define a routine: a prompt + one or more GitHub repos + triggers + connectors
- Each run clones your repo fresh, does the work in an isolated cloud environment, and destroys the environment after
- If Claude makes changes, it pushes them to a `claude/`-prefixed branch on your real GitHub repo
- Every run creates a session on claude.ai where you can review what Claude did, continue the conversation, or create a PR
- Actions happen as YOU (commits carry your GitHub user, Slack messages use your account)

**Analogy:** It's like hiring a contractor who clones your repo, works on a separate branch, pushes it, and leaves. You review and decide what to merge.

---

## CLAUDE.md Makes Routines Smart

Routines clone your repo fresh every run. That means they read your `CLAUDE.md` file automatically.

This is how you go from generic AI runs to context-aware ones:
- Coding standards, architecture notes, project conventions -- all loaded before Claude writes a line
- You can include instructions like "always run tests before pushing" or "never modify the auth module without flagging it"
- The better your CLAUDE.md, the better every routine performs. It's basically a briefing doc for your autonomous worker.

**Tip:** If a routine covers a specific subfolder, you can also put a CLAUDE.md inside that subfolder for more targeted instructions.

---

## Three Trigger Types

| Trigger | How It Fires | Example |
|---------|-------------|---------|
| **Schedule** | Cron-based (hourly, daily, weekly). Min interval: 1 hour. | "Every weeknight at 9pm, triage new issues" |
| **API** | POST to a dedicated endpoint with a bearer token | "When Sentry fires an alert, Claude diagnoses and opens a fix PR" |
| **GitHub** | Reacts to repo events (PRs, pushes, issues, releases, workflow runs, etc.) | "On every new PR, run my team's review checklist" |

- You can combine multiple triggers on one routine (e.g., runs nightly AND on every new PR)
- GitHub triggers support 18+ event types including PRs, pushes, issues, releases, check runs, workflow runs, discussions, merge queue entries
- PR filters available: author, title, body, base/head branch, labels, draft status, merged status, from fork

---

## How This Compares to What Already Existed

| | Routines (NEW) | Desktop Scheduled Tasks | /loop |
|---|---|---|---|
| Runs on | Anthropic cloud | Your machine | Your machine |
| Needs machine on? | No | Yes | Yes |
| Needs open session? | No | No | Yes |
| Survives restarts? | Yes | Yes | No |
| Local file access? | No (fresh clone) | Yes | Yes |
| Permission prompts? | None (fully autonomous) | Configurable | Inherits session |
| Min interval | 1 hour | 1 minute | 1 minute |

**Key difference:** Routines run autonomously on cloud infra. No approval prompts, no machine required. Desktop tasks and /loop are local.

**Existing Desktop tasks do NOT migrate.** They're a completely separate system. If you want something in the cloud, you recreate it as a new routine manually.

---

## Environments (How API Keys Work)

Your `.env` is gitignored, so the fresh clone won't have it. Routines solve this with **Environments**:

- **Environment variables** - put your API keys here (ClickUp, YouTube, whatever). Claude reads them like normal env vars during the run.
- **Network access** - controls what the routine can reach on the internet
- **Setup script** - install commands that run before each session (npm install, pip install, etc.)

You configure environments at claude.ai before creating the routine, then select one per routine.

**The .env Gotcha (learned the hard way):** If your scripts use `python-dotenv` or any library that loads a `.env` file, they will fail silently in routines because there's no `.env` file to load. The fix: make your scripts read environment variables directly with `os.environ["KEY_NAME"]` instead of relying on dotenv. Your keys are already set as real environment variables in the routine's environment -- dotenv is unnecessary and will break things.

---

## Network Access: Trusted vs Full

| Setting | What It Means |
|---------|--------------|
| **Trusted** | Can only reach known/vetted services (GitHub, Anthropic, configured connectors). Whitelist approach. |
| **Full** | Can make outbound requests to anything on the internet. No restrictions. |

**If your routine needs to hit external APIs** (ClickUp, YouTube, Google Workspace, etc.), you need **Full**. Trusted will block those requests with a 403 tunnel error.

**Risk of Full:** If Claude reads malicious content during a run (crafted PR description, compromised dependency), it could theoretically be tricked into sending data to an external server. With Trusted, that outbound request gets blocked even if Claude is tricked.

**Practical risk for private repos where you control the inputs:** Very low. This matters more if you're processing untrusted input like public PRs from strangers.

---

## Connectors (Managed Integrations)

Routines can't use your local MCP servers. Instead, they use **Connectors** -- Anthropic's managed integrations that run in the cloud.

Available connectors at launch:
- **Slack** -- read/post messages, respond to threads
- **Linear** -- create/update issues, read project state
- **Jira** -- ticket management
- **Google Drive** -- read/write docs and files
- **GitHub** (built-in) -- PRs, issues, code changes

You attach connectors when creating a routine. Each connector authenticates through your account, so actions happen as you.

**Key difference from MCP:** MCP servers are local processes you run yourself. Connectors are hosted by Anthropic and pre-configured. You can't bring your own custom MCP server into a routine -- if a service isn't available as a connector, you'll need to hit its API directly (which requires Full network access).

---

## Security Details

- **Branch safety:** By default, routines can only push to `claude/`-prefixed branches. Toggle "Allow unrestricted branch pushes" per repo to remove this (but probably don't).
- **API trigger protection:** Each routine gets its own bearer token. Someone needs both the URL and the token to trigger a run. Tokens are shown once, can be regenerated or revoked.
- **If a token leaks:** Someone could spam-trigger runs and burn your daily usage cap. Revoke and regenerate immediately.
- **Daily run cap:** There's a per-account limit on how many runs can start per day. Orgs with extra usage enabled can exceed this on metered overage.
- **Everything runs as you:** Commits, PRs, Slack messages, Linear tickets -- all carry your identity. If a routine posts to your team's Slack channel at 3am, your name is on it. If it opens a PR with a bad fix, your GitHub profile is the author. Think carefully before connecting routines to communication tools -- your reputation is on the line, not Claude's.

---

## Limits and Quotas

- **Daily run cap by plan:**
  - Pro: 5 runs/day
  - Max: 15 runs/day
  - Team: 25 runs/day
  - Enterprise: 25 runs/day
  - If you hit the cap, orgs with extra usage enabled can exceed it on metered overage.
- **Minimum schedule interval:** 1 hour. You can't schedule something every 5 minutes.
- **Resource limits per run:** 4 vCPUs, 16 GB RAM, 30 GB disk. Sessions can be terminated if they exceed memory limits (e.g., during large builds). No publicly documented wall-clock timeout yet, but the feature is in research preview so limits may change.
- **Token budget:** Each run consumes tokens from your normal subscription usage. A complex routine that reads lots of files and writes lots of code burns through tokens fast.
- **Repo size:** The environment clones your repo fresh each time. Very large repos will eat into your run time just on the clone step.

**Bottom line:** Start simple, monitor your usage on claude.ai, and scale up once you understand how much each routine costs.

---

## What Persists vs What Gets Destroyed

**Persists:**
- `claude/` branches pushed to your GitHub repo
- The session on claude.ai (you can review, continue, create PRs)

**Destroyed after each run:**
- The cloud environment (cloned repo, temp files, installed packages)

Every run is a clean slate. No state carries over between runs.

---

## What Routines Can't Do

Not everything belongs in a routine. These will fail or won't work:

- **Anything needing a persistent browser session** -- Playwright/Puppeteer scripts that require login cookies or session state. The environment is destroyed after each run, so there's no saved browser state. (We tested this with Skool automation -- doesn't work.)
- **GUI interaction** -- No display, no desktop, no clicking through UIs
- **Local-only services** -- Can't reach localhost databases, local APIs, or services running on your machine
- **Large local files** -- Only what's in the GitHub repo is available. Your local Obsidian vault, video files, databases -- none of it exists in the routine's environment.
- **Resource-heavy processes** -- Each run gets 4 vCPUs, 16 GB RAM, 30 GB disk. If your task exceeds memory limits (large builds, heavy data processing), the session gets terminated.
- **Stateful workflows** -- No state carries between runs. If step 2 depends on something step 1 saved to disk yesterday, it won't be there.

**Rule of thumb:** If it needs something that isn't in your repo or reachable via an API, it won't work in a routine.

---

## Writing Good Routine Prompts

The prompt IS the routine. A vague prompt gets vague results. Tips:

- **Be specific about what to do and where.** "Fix flaky tests" is bad. "Scan `src/tests/` for tests that have failed intermittently in the last 5 CI runs, identify the root cause, and open a fix PR for each" is good.
- **Name the files and directories.** Claude is cloning your repo fresh with no prior context (beyond CLAUDE.md). Point it to exactly where to look.
- **State what success looks like.** "All modified tests should pass locally before pushing."
- **Set boundaries.** "Only modify files in `src/utils/`. Do not touch the API layer." Prevents Claude from going rogue on a broad codebase.
- **Include the output format.** "Push changes to a `claude/fix-flaky-tests` branch and open a draft PR with a summary of what changed and why."
- **Leverage CLAUDE.md.** Put stable instructions in CLAUDE.md, put run-specific instructions in the prompt. Don't repeat yourself.

---

## Where to Create Routines

- **Web:** claude.ai/code/routines
- **CLI:** `/schedule` command (creates scheduled routines only; API and GitHub triggers need the web UI)
- **Desktop app:** New task > New remote task

All three write to the same cloud account. A routine created in CLI shows up on the web immediately.

---

## Why This Beats Normal Automation

A typical automation (n8n, Zapier, a cron script) runs a fixed sequence of steps. If step 3 fails, the whole thing fails. You get an error log and have to fix it yourself.

Routines are fundamentally different. When you fire a routine -- especially via the API trigger -- you're not running a script. You're injecting a prompt into a full Claude Code session. That means you get the entire agentic reasoning loop:

- **Self-correction:** If Claude hits an error mid-run, it can read the error, reason about what went wrong, and try a different approach. A normal automation just dies.
- **Context-aware problem solving:** Claude can read your codebase, check file contents, look at test output, and adapt. It's not following a rigid flowchart.
- **The API trigger is the big one.** You can wire any external system (Sentry alert, CI failure, webhook from your app) to fire a POST request that spins up a full agentic session. That's not "run this script" -- that's "here's a problem, go figure it out."

**The catch: test everything first.** The agentic loop only works if the environment is set up correctly. If your routine hits a permission error, a missing API key, or a network block, Claude might spend its entire run trying to work around an infrastructure problem instead of doing the actual task. Before you trust any routine to run autonomously:

1. Use "Run now" and watch the session live
2. Verify all API keys are in the environment
3. Confirm network access is set correctly (Trusted vs Full)
4. Make sure your prompt tells Claude what to do when it hits a wall ("if X fails, log the error and stop" vs "if X fails, try Y")

Once the environment is clean and the prompt is solid, you get something no traditional automation gives you: a worker that can think through problems instead of just reporting them.

---

## Coolest Real-World Use Cases (From Launch Day)

**Event-driven (GitHub triggers):**
- PR merge triggers auto-docs update ("Docs are just current now - no one has to remember")
- PR opened triggers automated code review against project's CLAUDE.md and style guide
- Any PR touching `/auth-provider` gets flagged and summarized to Slack

**Scheduled (cron):**
- Nightly bug triage: pull top Linear issue at 2am, attempt fix, open draft PR
- Flaky test cleanup: nightly scan for random pass/fail tests, open fix PRs
- Weekly backlog grooming
- Dependency audits, code cleanups, release notes on autopilot
- Weekly docs drift detection (scan merged PRs, flag stale docs, open update PRs)

**API-triggered:**
- Fire from CI/CD or alerting (Grafana, Sentry): alert payload hits endpoint, Claude triages and posts to #oncall
- Post-deploy smoke tests: CD pipeline calls routine, Claude runs checks, posts go/no-go
- One user migrating 8 marketing agents to routines

**The quote that captures the vibe:** "It's not just 'AI helps me code faster.' It's 'AI handles entire repeatable workflows autonomously.'"

---

## Common Questions People Will Ask

**Q: Do I need to know cron syntax?**
A: No. You can pick presets (hourly, daily, weekdays, weekly) or use `/schedule` in CLI with plain language. Custom cron is available but not required.

**Q: Can it access my local files?**
A: No. It clones your repo fresh each time. Anything not in the repo (local files, Obsidian vaults, local databases) is not available.

**Q: What models can it use?**
A: You pick the model when creating the routine. Model selector is in the prompt input.

**Q: Can I watch it work in real time?**
A: Yes. API triggers return a session URL you can open in the browser to watch live. Scheduled/GitHub runs appear as sessions on claude.ai.

**Q: Can it use my MCP servers?**
A: It uses "Connectors" (Anthropic's managed MCP integrations for Slack, Linear, Google Drive, etc.). Your local MCP servers don't carry over - you configure connectors per routine.

**Q: Can teammates use my routines?**
A: No. Routines belong to your individual claude.ai account. Not shared with teammates.

**Q: What's the cost?**
A: Draws down your normal subscription usage. Plus a daily cap on routine runs per account.

**Q: What happens when a run fails?**
A: Every run creates a session on claude.ai, successful or not. You can open the session, see exactly where it went wrong, and continue the conversation to fix it or retry. There's no automatic retry -- if a scheduled run fails at 2am, you'll see the failed session next time you check. Changes only land on `claude/` branches, so a failed run can't break your main branch.

**Q: Can I test before going live?**
A: Yes. "Run now" button triggers immediately without waiting for the schedule. Always test with "Run now" before trusting a schedule or API trigger. Review the session output to make sure it did what you expected.
