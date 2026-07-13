# =============================================================================
# YellowDog.gd — G1-08 YELLOW DOG. Wild Card object fighter. The mascot.
# Kit: Brick Toss, Smoke Cloud, Deadpan Charge.
# Tuning lives in GameConstants.YELLOW_DOG (Project Rule 1).
#
# !!! BALANCE: brick damage is flagged OVERPOWERED in the bible (§04). The
# number lives in GameConstants.YELLOW_DOG["brick_damage"] — tune it there.
#
# Projectiles are STUBBED until the hitbox/hurtbox milestone; Brick Toss will
# become BrickProjectile.tscn (see ROADMAP.md).
# =============================================================================
class_name YellowDog
extends CharacterBase


func _init() -> void:
	display_name = "YELLOW DOG"
	tuning = GameConstants.YELLOW_DOG


# Special A: Brick Toss.
func special_a() -> void:
	# TODO(roadmap: projectiles milestone): spawn BrickProjectile.tscn with
	# damage = tuning["brick_damage"]. Gray-box stub:
	print("[YELLOW DOG] Brick Toss (stub) — BrickProjectile.tscn not built yet. ",
			"Brick damage is ", tuning["brick_damage"], " and FLAGGED OP.")


# Special B: Smoke Cloud.
func special_b() -> void:
	# TODO(roadmap: projectiles milestone): smoke cloud that hides Yellow Dog
	# for tuning["smoke_cloud_duration_seconds"]. Gray-box stub:
	print("[YELLOW DOG] Smoke Cloud (stub)")


# Deadpan Charge uses the universal hold-to-charge entry point.
func charge_attack() -> void:
	# TODO(roadmap: after hitboxes): armor during charge walk.
	start_attack("heavy")
