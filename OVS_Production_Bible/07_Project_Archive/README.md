# 07 — Project Archive

**What lives here:** Every OVS project, organized by status.

```
_ACTIVE/    ← Projects currently in production
_SHIPPED/   ← Finished and released projects
_SHELVED/   ← Paused or indefinitely deferred projects
```

### Subfolder Structure (per project)

Each project lives in its own folder: `[YYYYMM]_[project_slug]/`

```
[project_folder]/
├── brief.md
├── treatment.md
├── shot_list.md
├── prompts/          ← prompt batch files
├── selects/          ← chosen generation outputs
├── raw_gen/          ← all generation outputs (unfiltered)
└── notes.md          ← production notes, decisions, changes
```

### Starting a New Project

1. Copy `_TEMPLATE/` into `_ACTIVE/`
2. Rename the folder to `[YYYYMM_project_slug]` — e.g. `202607_cadillac_noir`
3. Fill in `brief.md` first, then work through the pipeline

**Move projects between `_ACTIVE/`, `_SHIPPED/`, `_SHELVED/` — never delete.**
