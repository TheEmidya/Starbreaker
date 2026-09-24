extends Node
class_name EntityHealthClass
signal knockback_applied(hitbox_area)
signal health_changed(_health : int)
signal health_depleted()

@export var entity : EntityClass
@export var entity_is_invincible : bool = false

@export var entity_max_health : float = 100.0:
	get():
		return entity_max_health * entity.entity_multipliers.health_multiplier

@onready var current_entity_health : float = entity_max_health:
	set(health_value):
		current_entity_health = health_value
		current_entity_health = int(clamp(current_entity_health, 0, entity_max_health))
		if current_entity_health <= 0:
			health_depleted.emit()
		else:
			health_changed.emit(int(current_entity_health))

func take_damage(hitbox_area : HitboxClass):
	current_entity_health -= hitbox_area.hitbox_data.damage_amount
	knockback_applied.emit(hitbox_area)

func apply_defense() -> int:
	var _applied_defense = 0
	return _applied_defense
