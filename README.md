# 2025May_Team04

## QuickPhrase — multilingual phrasebook

The QuickPhrase application code now lives in a single, buildable project:

**➡️ https://github.com/bthoreau88/dev-brandon**

The multilingual phrase feature that previously lived here as commented-out
reference code (`MultilingualPhrase`, `PhrasePack`, `TranslatedPhraseScreen`)
has been ported into that repository as live, wired-up Kotlin/Compose code,
alongside the existing login and registration flow. That repo has the full
Gradle build; this one never did.

Please make all application changes in `dev-brandon`. The old commented-out
copies were removed from this repository to prevent two diverging versions.

This repository still hosts the team's Discord notification workflow
(`.github/workflows/discord.yml`).
