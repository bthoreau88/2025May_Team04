# OVS Prompt Anatomy — Seedance 2.0 Reference

## Structure

```
[LENS] [SUBJECT] [ACTION/STATE] [ENVIRONMENT] [LIGHTING] [GRADE/TEXTURE] [REFERENCE VECTOR] -- [NEGATIVE PROMPT]
```

---

## Element Guide

### [LENS]
Focal length + camera movement. Always first.

```
85mm medium close-up, locked camera
85mm medium close-up, slow rack focus from [A] to [B]
40mm wide, slow push in
135mm telephoto, stationary, subject enters frame right
21mm wide establishing, locked
```

### [SUBJECT]
Age, build, expression, clothing — specific enough to generate.

```
A man in his mid-40s, lean jaw, watchful eyes, [clothing description]
A woman in her late 30s, composed, slight tension in jaw, [clothing description]
[Object/vehicle/location description in same specificity]
```

### [ACTION/STATE]
What's happening. Active verb or held state.

```
standing at a window, not looking out, cigarette burning in right hand
driving, hands at ten and two, eyes checking the mirror
sitting completely still, listening to something off-screen
```

### [ENVIRONMENT]
Location, era, time of day, weather, ambient light state.

```
a motel room, late 1960s, overcast daylight through thin curtains, single lamp on
exterior roadside diner, night, neon sign buzzing, rain on pavement
interior of a 1966 Cadillac DeVille, moving, night, headlights on oncoming signs
```

### [LIGHTING]
Dominant source first, secondary, shadow quality, color temperature.

```
practical lamplight warm amber dominant, cold window secondary, hard shadow on wall
neon sign exterior fill, deep shadow interior, red-orange cast on wet pavement
single bare bulb overhead, hard downward shadow, subject half in darkness
```

### [GRADE/TEXTURE]
Film stock, grain level, color character.

```
35mm grain visible, crushed blacks, muted warm palette, slight green shadow push
16mm grain heavy, blown highlights, high contrast, desaturated mids
35mm fine grain, pulled-down highlights, amber midtone, teal-shadow grade
```

### [REFERENCE VECTOR]
Tonal reference. Film title + DP or photographer.

```
visual register of No Country for Old Men, Roger Deakins
visual register of Se7en, Darius Khondji
visual register of Gordon Parks photography, 1960s
visual register of Heat, Dante Spinotti, night exterior
```

---

## Full Example

```
85mm medium close-up, slow rack focus from hands to face — A man in his mid-40s, lean jaw, 
dark wool suit, white shirt open at collar — standing at a motel room window, not looking out, 
cigarette burning in right hand — late 1960s motel room, thin curtain diffusing flat overcast 
daylight, one practical table lamp — practical warm amber dominant, cold window secondary fill, 
hard shadow on wall behind him — 35mm grain visible, crushed blacks, muted warm palette, slight 
green shadow push — visual register of No Country for Old Men, Roger Deakins — no digital sheen, 
no modern clothing, no HDR look, no stock footage lighting, no visible AI artifacts, no lens flare
```
