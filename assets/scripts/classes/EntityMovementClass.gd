extends Node
class_name EntityMovementClass
@export var entity : EntityClass
@export var entity_is_immovable : bool = false
@onready var entity_movement_direction : Vector2 = Vector2.ZERO
@export var entity_movement_speed : float = 0.0:
	get():
		var final_entity_speed = entity_movement_speed * entity.entity_multipliers.speed_multiplier
		return final_entity_speed
@export var entity_acceleration : float = 0.0

func _physics_process(_delta: float) -> void:
	entity.move_and_slide()

func move(input : Vector2, _delta : float):
	if entity_is_immovable:
		return
	
	entity.velocity = entity.velocity.move_toward(input * entity_movement_speed, entity_acceleration)
