# =============================================================================
# GameConstants.gd — THE ONE PLACE ALL TUNABLE NUMBERS LIVE (Project Rule 1).
# Registered as an autoload singleton named "GameConstants" in project.godot,
# so every script can read e.g. GameConstants.MAX_HEALTH directly.
# Values come from the franchise bible §05 (mechanics) and §06 (art spec).
# Balance changes happen HERE, with a comment noting the reason — never inline
# in a character or combat script.
# =============================================================================
extends Node

# --- Engine timing --------------------------------------------------------
# Frame data below is authored against 60 fps (fighting-game convention).
const FPS: int = 60

# --- Health & rounds (bible §05) ------------------------------------------
const MAX_HEALTH: float = 1000.0
const ROUNDS_TO_WIN: int = 2            # best of 3
const ROUND_TIME_SECONDS: float = 60.0
const PRE_ROUND_COUNTDOWN: int = 3      # "3, 2, 1, FIGHT!"
const BETWEEN_ROUNDS_DELAY: float = 2.5 # seconds showing the round result

# --- HANDZ Meter (bible §05) ----------------------------------------------
# Meter runs 0-100 (%).
const METER_MAX: float = 100.0
const METER_GAIN_HIT_LANDED: float = 3.0
const METER_GAIN_HIT_TAKEN: float = 5.0
const METER_GAIN_PARRY_SUCCESS: float = 15.0
const METER_GAIN_PARRY_FAIL: float = 2.0
const METER_COST_EX: float = 25.0
const METER_COST_BREAK: float = 50.0
const METER_COST_SUPER: float = 100.0
const METER_ROUND_CARRY: float = 0.5    # 50% of meter carries into the next round

# --- Desperation Mode (bible §05) -----------------------------------------
const DESPERATION_HP_THRESHOLD: float = 0.20   # activates at 20% health
const DESPERATION_DAMAGE_BONUS: float = 0.15   # +15% outgoing damage
const DESPERATION_SUPER_COST: float = 50.0     # super costs 50% meter instead of 100%

# --- Parry (bible §05) -----------------------------------------------------
const PARRY_WINDOW_FRAMES: int = 6
const PARRY_SUCCESS_ADVANTAGE_FRAMES: int = 12 # attacker is stunned this long
const PARRY_WHIFF_RECOVERY_FRAMES: int = 24    # punishable if you parry nothing

# --- Blocking ---------------------------------------------------------------
const BLOCK_CHIP_MULTIPLIER: float = 0.12      # blocked hits deal 12% chip damage
const BLOCK_TAP_DURATION_FRAMES: int = 20      # 2-finger tap blocks for this long
const BLOCKSTUN_FRAMES: int = 8

# --- Universal attack data --------------------------------------------------
# damage      : raw damage against MAX_HEALTH 1000
# startup     : frames before the hitbox turns on
# active      : frames the hitbox stays on (the hit can only land here)
# recovery    : frames after the hitbox turns off before you can act again
# hitstun     : frames the victim is frozen on a clean hit
# hitbox_size : hitbox rectangle, placed in front of the fighter
#               (reach = half hurtbox width 30 + hitbox_size.x)
# hitbox_y    : vertical center of the hitbox (0 = chest, + = low, - = high)
const ATTACKS: Dictionary = {
	"light": {
		"damage": 40.0, "startup": 4, "active": 3, "recovery": 8, "hitstun": 10,
		"hitbox_size": Vector2(120, 80), "hitbox_y": 0.0,
	},
	"medium": {
		"damage": 70.0, "startup": 7, "active": 4, "recovery": 12, "hitstun": 14,
		"hitbox_size": Vector2(140, 90), "hitbox_y": 0.0,
	},
	"heavy": {
		"damage": 110.0, "startup": 11, "active": 5, "recovery": 18, "hitstun": 20,
		"hitbox_size": Vector2(160, 100), "hitbox_y": 0.0,
	},
	"low": {
		"damage": 55.0, "startup": 6, "active": 3, "recovery": 12, "hitstun": 12,
		"hitbox_size": Vector2(120, 60), "hitbox_y": 55.0,
	},
	"jump_attack": {
		"damage": 65.0, "startup": 8, "active": 6, "recovery": 14, "hitstun": 14,
		"hitbox_size": Vector2(140, 90), "hitbox_y": -40.0,
	},
	"super": {
		"damage": 250.0, "startup": 14, "active": 8, "recovery": 30, "hitstun": 40,
		"hitbox_size": Vector2(190, 140), "hitbox_y": 0.0,
	},
}

# --- Bodies & hit detection --------------------------------------------------
const HURTBOX_SIZE: Vector2 = Vector2(60, 180)  # matches the placeholder body
# Draws hurtboxes (green) and active hitboxes (red) in-game. Turn off for
# demos; costs nothing when false.
const DEBUG_SHOW_HITBOXES: bool = true

# --- Movement (gray-box defaults; per-character overrides below) ------------
const WALK_SPEED: float = 300.0
const DASH_SPEED: float = 650.0
const DASH_DURATION_FRAMES: int = 10
# Forward swipe means dash when the opponent is farther than this, otherwise
# it is the medium attack (bible §05: "swipe -> = medium/dash").
const DASH_TRIGGER_DISTANCE: float = 260.0
const JUMP_VELOCITY: float = -700.0
const GRAVITY: float = 2000.0
const STAGE_EDGE_MARGIN: float = 40.0           # fighters can't leave the screen

# --- Pushback (Phase 2) -------------------------------------------------------
# Initial backward velocity (px/s) given to the victim, decaying at
# PUSHBACK_DECAY px/s^2. Blocked hits shove harder but deal only chip.
const PUSHBACK_HIT_SPEED: float = 320.0
const PUSHBACK_BLOCK_SPEED: float = 480.0
const PUSHBACK_DECAY: float = 1800.0

# --- Gesture recognition (GestureInput.gd) ---------------------------------
const TAP_MAX_DURATION_MS: int = 220        # press shorter than this = tap
const TAP_MAX_DISTANCE_PX: float = 24.0     # finger drift allowed in a tap
const SWIPE_MIN_DISTANCE_PX: float = 60.0   # travel needed to count as a swipe
const HOLD_MIN_DURATION_MS: int = 450       # press longer than this = charge
const SPECIAL_SEQUENCE_WINDOW_MS: int = 400 # max gap between the two swipes of ←→ / ↓→

# --- Per-character tuning ---------------------------------------------------
# G1-01 SOL TIGRE — Rushdown + Tiger Companion. Fast, slightly light damage.
const SOL_TIGRE: Dictionary = {
	"walk_speed": 360.0,
	"damage_multiplier": 0.95,
	"tiger_cooldown_seconds": 6.0, # companion assist cooldown (companion stubbed)
}

# G1-08 YELLOW DOG — Wild Card object fighter. Slower, hits hard.
const YELLOW_DOG: Dictionary = {
	"walk_speed": 270.0,
	"damage_multiplier": 1.0,
	# !!! BALANCE FLAG (bible §04): BRICK_DAMAGE is OVERPOWERED at 90 and the
	# bible says to tune it. Left at the flagged value so the problem is
	# visible in playtests; reduce it here (nowhere else) when tuning.
	"brick_damage": 90.0,
	"smoke_cloud_duration_seconds": 3.0,
}

# --- Art / sprite spec (bible §06) — used by tooling & import checks --------
const SPRITE_BASE_HEIGHT_PX: int = 180   # fighter height at 1x
const SPRITE_RENDER_SCALE: int = 3       # author art at 3x
const SPRITE_MIN_FRAMES: int = 32        # minimum animation frames per fighter
const PORTRAIT_SIZE_PX: int = 512        # 512x512 portraits
const STAGE_WIDTH_PX: int = 640          # stage size at 1x
const STAGE_HEIGHT_PX: int = 360
