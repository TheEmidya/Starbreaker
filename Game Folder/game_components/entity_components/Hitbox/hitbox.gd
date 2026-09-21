extends Area2D
class_name Hitbox

@export var is_hitbox_disabled := false  # Flag to disable or enable the hitbox
@export var hitbox_data : HitboxData

func _ready() -> void:
	self.area_entered.connect(hitbox_detection, 1)

func hitbox_detection(area : Area2D):
	if area is Hurtbox:
		hitbox_data.position = self.global_position
		events.hitbox_interaction.emit(self)
		area.hurtbox_detection.emit(self.hitbox_data)

func _physics_process(_delta: float) -> void:
	check_disable_mode_process()

func check_disable_mode_process():
	self.monitorable = !is_hitbox_disabled
	self.monitoring = !is_hitbox_disabled
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = is_hitbox_disabled
		if child is CollisionPolygon2D:
			child.disabled = is_hitbox_disabled
