extends Node
class_name EntityHealthClass
signal health_changed(_health : int)

@export var entity : EntityClass
@export var entity_is_invincible : bool = false

@export var entity_max_health : float = 100.0:
	get():
		return entity_max_health * entity.entity_multipliers.health_multiplier

@onready var current_entity_health : float = entity_max_health:
	set(health_value):
		var _final_health = current_entity_health + health_value
		_final_health = int(clamp(_final_health, 0, entity_max_health))
	get():
		var _final_health = entity_max_health * entity.entity_multipliers.health_multiplier
		_final_health = clamp(_final_health, 0, entity_max_health)
		health_changed.emit(int(_final_health))
		return int(_final_health)

func take_damage():
	pass

func apply_defense() -> int:
	var _applied_defense = 0
	return _applied_defense
