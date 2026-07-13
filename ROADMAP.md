# THESE HANDZ — 26-Week Build Roadmap (Game 1)

Solo beginner developer, 5–15 hrs/week. One phase at a time; every phase ends
with a milestone test you can run yourself. Never move on with a red milestone.

Legend: `[x]` done · `[~]` in progress · `[ ]` not started

---

## Phase 0 — Project setup (weeks 1–2) — DONE

- [x] Godot 4.2+ project opens; scaffold scripts imported
- [x] `GameConstants` + `GestureInput` registered as autoload singletons
- **Milestone test:** project runs from the editor with no script errors. ✅

## Phase 1 — Gray-box fight loop (weeks 3–6) — IN PROGRESS

- [x] 1. `FightScene.tscn` with two placeholder rectangles
       (CharacterBody2D + CollisionShape2D + ColorRect)
- [x] 2. Wire GestureInput → InputRouter → both characters; keyboard attacks land
- [x] 3. Health bars + meter bars (ProgressBar) connected to existing signals
- [x] 4. ParrySystem + RoundManager integration; full best-of-3 loop with no art
- [ ] 5. Hand-test every gesture on a real phone (tap, all 4 swipes, ←→, ↓→,
       hold, 2-finger tap, 2-finger swipe) and tune the recognizer thresholds
       in GameConstants if anything feels off
- **Milestone test:** play a full best-of-3 on desktop keyboard AND on a phone,
  KO and time-out both end rounds, meter carries 50% between rounds.

## Phase 2 — Real hit detection (weeks 7–9)

- [ ] Hitbox/hurtbox Area2D pairs with per-attack frame timing
      (replace the distance check in `CharacterBase._opponent_in_range`)
- [ ] Walk/dash movement + pushback on hit and block
- [ ] Debug overlay: show active hitboxes as colored rects
- **Milestone test:** whiffing at max range visibly misses; hits connect only
  during active frames.

## Phase 3 — First two real fighters (weeks 10–14)

- [ ] SOL TIGRE full kit — `TigerCompanion.tscn` (assist entity, cooldown)
- [ ] YELLOW DOG full kit — `BrickProjectile.tscn`, Smoke Cloud, Deadpan Charge
      (tune the flagged brick damage in GameConstants!)
- [ ] `ChainProjectile.tscn` groundwork (shared projectile base for later cast)
- **Milestone test:** mirror-less match Sol Tigre vs Yellow Dog with all
  specials functional, still placeholder art.

## Phase 4 — Sprites & animation (weeks 15–19)

- [ ] Sprite pipeline per bible §06: 180px base @1x, authored 3x,
      32+ frames per fighter, portraits 512×512
- [ ] AnimationPlayer/AnimatedSprite2D driven by FightState
- [ ] First stage background 640×360 @1x
- **Milestone test:** both fighters fully animated (idle, walk, all attacks,
  block, parry, hit, KO) at stable 60fps on a mid-range phone.

## Phase 5 — Remaining 6 fighters, gray-box first (weeks 20–24)

- [ ] Crown Saint, The Architect, Dotty, Fresh, Cyborg Stitch, Purple Thread
      — kits per bible §04, each gray-boxed then animated
- **Milestone test:** full 8-fighter select, any matchup completes a match.

## Phase 6 — Alpha polish (weeks 25–26)

- [ ] Character select + main menu (touch-first UI)
- [ ] SFX/music pass, hitstop, screen shake
- [ ] iOS + Android export configs; on-device performance pass
- **Milestone test:** clean install on both platforms, full loop
  menu → fight → rematch with no crashes.

Post-alpha (NOT before): backend (Firebase/Supabase), online, Game 2 roster.
