extends Area2D
class_name HurtboxClass
signal hurtbox_entered(area)

@export var entity_health : EntityHealthClass

func _ready() -> void:
	self.connect("area_entered", area_entered, 1)

func area_entered(area : Area2D):
	if area != HitboxClass:
		return
	
	if area.entity != EntityClass:
		return
	
	hurtbox_entered.emit(area)
