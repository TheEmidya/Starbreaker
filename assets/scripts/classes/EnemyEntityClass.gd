extends EntityClass
class_name EnemyEntityClass

@onready var entity_movement_class: EntityMovementClass = %EntityMovementClass
@onready var entity_health_class: EntityHealthClass = %EntityHealthClass
@onready var hurtbox_class: HurtboxClass = %HurtboxClass

func _ready() -> void:
	entity_health_class.knockback_applied.connect(entity_movement_class.apply_knockback, 1)
	entity_health_class.health_depleted.connect(death, 0)

func death():
	queue_free()
