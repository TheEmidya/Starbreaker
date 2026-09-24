extends Area2D
class_name HitboxClass
signal hitbox_connection(hurtbox)

@export var entity : EntityClass
@export var hitbox_data : HitboxDataResource

func _ready() -> void:
	area_entered.connect(hitbox_entered, 1)

func hitbox_entered(area : Area2D):
	if area is not HurtboxClass:
		return
	
	hitbox_connection.emit(area)
