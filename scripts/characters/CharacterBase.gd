# =============================================================================
# CharacterBase.gd — every fighter extends this.
# Owns: health, the FightState machine, damage application, HANDZ meter and
# parry integration, and Desperation Mode.
#
# Project Rule 2: characters NEVER read input directly. The only way input
# reaches a fighter is receive_gesture(), called by InputRouter. There is no
# Input.is_action_pressed() anywhere in this file or any fighter script.
#
# Godot note (state machines): we use a simple enum + frame counter instead
# of separate state nodes. `_state_frames` counts down in _physics_process;
# when it hits 0 the state resolves (attack hits, parry whiffs, stun ends).
# Fighting games think in frames, not seconds — at 60 fps, 6 frames = 0.1 s.
# =============================================================================
class_name CharacterBase
extends CharacterBody2D

signal health_changed(current: float, max_value: float)
signal defeated(player_id: int)
signal desperation_activated(player_id: int)
signal parry_succeeded(player_id: int)

enum FightState { IDLE, ATTACKING, BLOCKING, PARRYING, HITSTUN, KO }

@export var player_id: int = 1

var display_name: String = "FIGHTER"
# Per-character tuning dictionary from GameConstants; fighters set this.
var tuning: Dictionary = {}

var health: float
var state: FightState = FightState.IDLE
var meter: HandzMeter
var parry: ParrySystem
var opponent: CharacterBase
var facing: int = 1                 # 1 = faces right, -1 = faces left
var desperation: bool = false
var spawn_position: Vector2

var _state_frames: int = 0          # frames left in the current state
var _attack_name: String = ""       # attack in progress, "" if none
var _attack_phase: String = ""      # "startup" or "recovery"
var _block_held: bool = false       # keyboard D held down


func _ready() -> void:
	health = GameConstants.MAX_HEALTH
	spawn_position = global_position

	meter = HandzMeter.new()
	meter.name = "HandzMeter"
	add_child(meter)

	parry = ParrySystem.new()
	parry.name = "ParrySystem"
	add_child(parry)
	parry.parry_whiffed.connect(_on_parry_whiffed)

	health_changed.emit(health, GameConstants.MAX_HEALTH)


func _physics_process(delta: float) -> void:
	# Gravity + floor collision keep the gray-box rectangles standing.
	if not is_on_floor():
		velocity.y += GameConstants.GRAVITY * delta
	velocity.x = 0.0
	move_and_slide()

	if state == FightState.KO:
		return

	parry.tick()
	_tick_state()


# --- Input entry point (called by InputRouter ONLY) -------------------------
func receive_gesture(gesture: Dictionary) -> void:
	if not can_act():
		# One exception: releasing block must always work.
		if gesture.get("action", "") == "block_end":
			_end_block()
		return

	match gesture["type"]:
		"tap":
			start_attack("light")
		"swipe":
			_handle_swipe(gesture["dir"])
		"action":
			_handle_action(gesture["action"])


func can_act() -> bool:
	return state == FightState.IDLE


func _handle_swipe(dir: String) -> void:
	var forward := "right" if facing == 1 else "left"
	if dir == forward:
		start_attack("medium")
	elif dir == "up":
		start_attack("jump_attack")
	elif dir == "down":
		start_attack("low")
	# Swipe away from the opponent: TODO(roadmap: movement pass): backdash.


func _handle_action(action: String) -> void:
	match action:
		"light", "medium", "heavy":
			start_attack(action)
		"super":
			try_super()
		"special_a":
			special_a()
		"special_b":
			special_b()
		"block_start":
			_block_held = true
			_start_block(0)      # 0 = held, ends on block_end
		"block_tap":
			_start_block(GameConstants.BLOCK_TAP_DURATION_FRAMES)
		"block_end":
			_end_block()
		"parry":
			_start_parry()
		"charge":
			charge_attack()


# --- Attacks ----------------------------------------------------------------
func start_attack(attack_name: String) -> void:
	if not GameConstants.ATTACKS.has(attack_name):
		push_warning("Unknown attack: " + attack_name)
		return
	state = FightState.ATTACKING
	_attack_name = attack_name
	_attack_phase = "startup"
	_state_frames = GameConstants.ATTACKS[attack_name]["startup"]


func try_super() -> void:
	# Desperation Mode discount: super at 50% meter (bible §05).
	var cost: float = GameConstants.DESPERATION_SUPER_COST if desperation \
			else GameConstants.METER_COST_SUPER
	if meter.try_spend(cost):
		start_attack("super")


# The moment the startup frames end and the hit "comes out".
func _resolve_attack_hit() -> void:
	var data: Dictionary = GameConstants.ATTACKS[_attack_name]
	if opponent != null and _opponent_in_range(data["range"]):
		var damage: float = data["damage"] * tuning.get("damage_multiplier", 1.0)
		if desperation:
			damage *= 1.0 + GameConstants.DESPERATION_DAMAGE_BONUS
		var landed: bool = opponent.take_hit(damage, self, data["hitstun"])
		if landed:
			meter.on_hit_landed()
	# If the hit got parried we are already in the parry stun — keep it.
	if state == FightState.ATTACKING:
		_attack_phase = "recovery"
		_state_frames = data["recovery"]


func _opponent_in_range(attack_range: float) -> bool:
	return absf(opponent.global_position.x - global_position.x) <= attack_range


# Returns true if the hit really connected (false if parried).
func take_hit(damage: float, attacker: CharacterBase, hitstun: int) -> bool:
	if state == FightState.KO:
		return false

	# Parry check first: an open window beats everything (bible §05).
	if state == FightState.PARRYING and parry.is_active():
		parry.succeed()
		meter.on_parry_success()
		attacker.apply_parry_stun()
		state = FightState.IDLE
		parry_succeeded.emit(player_id)
		return false

	if state == FightState.BLOCKING:
		_apply_damage(damage * GameConstants.BLOCK_CHIP_MULTIPLIER)
		# Blocking holds; just add a touch of blockstun by extending the state.
		if _state_frames > 0:
			_state_frames += GameConstants.BLOCKSTUN_FRAMES
		return false

	_apply_damage(damage)
	meter.on_hit_taken()
	if state != FightState.KO:
		state = FightState.HITSTUN
		_state_frames = hitstun
	return true


func _apply_damage(damage: float) -> void:
	health = maxf(health - damage, 0.0)
	health_changed.emit(health, GameConstants.MAX_HEALTH)

	if not desperation and health <= GameConstants.MAX_HEALTH * GameConstants.DESPERATION_HP_THRESHOLD:
		desperation = true
		desperation_activated.emit(player_id)

	if health <= 0.0:
		state = FightState.KO
		defeated.emit(player_id)


# The defender's "12-frame advantage": the parried attacker is locked out.
func apply_parry_stun() -> void:
	state = FightState.HITSTUN
	_attack_name = ""
	_state_frames = GameConstants.PARRY_SUCCESS_ADVANTAGE_FRAMES


# --- Block & parry ----------------------------------------------------------
func _start_block(frames: int) -> void:
	state = FightState.BLOCKING
	_state_frames = frames


func _end_block() -> void:
	_block_held = false
	if state == FightState.BLOCKING:
		state = FightState.IDLE
		_state_frames = 0


func _start_parry() -> void:
	state = FightState.PARRYING
	parry.begin()
	_state_frames = 0 # ParrySystem owns this timer; see _on_parry_whiffed.


func _on_parry_whiffed() -> void:
	if state != FightState.PARRYING:
		return
	# Whiffed parry = punishable recovery + 2% consolation meter (bible §05).
	meter.on_parry_fail()
	state = FightState.HITSTUN
	_state_frames = GameConstants.PARRY_WHIFF_RECOVERY_FRAMES


# --- Per-frame state resolution ---------------------------------------------
func _tick_state() -> void:
	if _state_frames <= 0:
		return
	_state_frames -= 1
	if _state_frames > 0:
		return

	match state:
		FightState.ATTACKING:
			if _attack_phase == "startup":
				_resolve_attack_hit()
			else:
				_attack_name = ""
				state = FightState.IDLE
		FightState.HITSTUN:
			state = FightState.IDLE
		FightState.BLOCKING:
			if not _block_held:
				state = FightState.IDLE
		_:
			pass


# --- Specials & charge: fighters override these ------------------------------
func special_a() -> void:
	pass


func special_b() -> void:
	pass


func charge_attack() -> void:
	# TODO(roadmap: after hitboxes): hold-to-charge heavy.
	pass


# --- Round lifecycle (called by RoundManager) --------------------------------
func reset_for_round() -> void:
	health = GameConstants.MAX_HEALTH
	desperation = false
	state = FightState.IDLE
	_state_frames = 0
	_attack_name = ""
	_block_held = false
	parry.cancel()
	global_position = spawn_position
	velocity = Vector2.ZERO
	meter.carry_over()
	health_changed.emit(health, GameConstants.MAX_HEALTH)
