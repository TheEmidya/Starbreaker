extends Area2D
class_name HurtboxClass
signal hurtbox_entered(area)

@export var entity_health : EntityHealthClass

func _ready() -> void:
	self.connect("area_entered", area_entered, 1)
	if is_instance_valid(entity_health):
		self.connect("hurtbox_entered", entity_health.take_damage, 1)
		print_debug("Hurtbox successfully connected to health component.")
	else:
		printerr("Area connection to health component unsuccessful.")

func area_entered(area : Area2D):
	if area is not HitboxClass:
		return
	
	hurtbox_entered.emit(area)
