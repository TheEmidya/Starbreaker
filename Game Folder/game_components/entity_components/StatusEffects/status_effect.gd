extends Node
class_name StatusEffect
var target : Entity = null
@onready var current_time = 0.0
@export var effect_name := ""
@export_multiline var effect_description := ""
var effect_duration := 5.0

func _physics_process(delta: float) -> void:
	current_time += delta
	if current_time >= effect_duration:
		self.queue_free()

func _exit_tree() -> void:
	target.entity_status_list.erase(self)
