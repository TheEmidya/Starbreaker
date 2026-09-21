extends Area2D
class_name Hurtbox
signal hurtbox_detection(hitbox_data : HitboxData)

@export var is_hurtbox_disabled := false

func _physics_process(_delta: float) -> void:
	check_disable_mode_process()

func check_disable_mode_process() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = is_hurtbox_disabled
		if child is CollisionPolygon2D:
			child.disabled = is_hurtbox_disabled
