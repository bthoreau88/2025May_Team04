# =============================================================================
# SolTigre.gd — G1-01 SOL TIGRE. Rushdown + Tiger Companion. Miami, FL.
# Fighting style: Tigre Flujo. Fast walk speed, slightly reduced damage
# (tuning in GameConstants.SOL_TIGRE — Project Rule 1).
#
# The tiger companion is STUBBED until the hitbox/hurtbox milestone; it will
# become TigerCompanion.tscn (see ROADMAP.md).
# =============================================================================
class_name SolTigre
extends CharacterBase


func _init() -> void:
	display_name = "SOL TIGRE"
	tuning = GameConstants.SOL_TIGRE


# Special A: tiger companion assist.
func special_a() -> void:
	# TODO(roadmap: projectiles milestone): spawn TigerCompanion.tscn, dash
	# across at tuning["tiger_cooldown_seconds"] cooldown. Gray-box stub:
	print("[SOL TIGRE] Tiger companion (stub) — TigerCompanion.tscn not built yet")


# Special B: Tigre Flujo rush — placeholder as a fast medium until real
# frame data exists.
func special_b() -> void:
	start_attack("medium")
