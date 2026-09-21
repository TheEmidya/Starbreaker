extends Resource
class_name HitboxData

@export var damage := 15.0
@export var knockback := 30.0
var position := Vector2.ZERO
@export var effect_list : Dictionary[String, float] = {}
