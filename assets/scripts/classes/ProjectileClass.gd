extends EntityClass
class_name ProjectileClass
@export var entity_movement_class: EntityMovementClass
var projectile_direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	entity_movement_class.move(projectile_direction, delta)
