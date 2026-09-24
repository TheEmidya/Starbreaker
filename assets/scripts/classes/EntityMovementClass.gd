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
@onready var last_knockback_direction : Vector2
@onready var last_knockback_amount : float

func _physics_process(_delta: float) -> void:
	knockback_tick(_delta)
	entity.move_and_slide()

func move(input : Vector2, _delta : float):
	if entity_is_immovable:
		return
	
	entity.velocity = entity.velocity.move_toward(input * entity_movement_speed, entity_acceleration)

func apply_knockback(hitbox_area : HitboxClass):
	last_knockback_direction = (entity.global_position - hitbox_area.global_position).normalized()
	last_knockback_amount = hitbox_area.hitbox_data.knockback_amount

func knockback_tick(delta : float):
	if last_knockback_amount < 0:
		return
	
	last_knockback_amount -= 100 * delta
	entity.velocity = last_knockback_direction * last_knockback_amount
