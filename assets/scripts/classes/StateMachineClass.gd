extends Node
class_name StateMachineClass

@export var intial_state : StateClass

var current_state : StateClass
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is StateClass:
			states[child.name.to_lower()] = child
			child.Transistioned.connect(on_child_transistion)
	if intial_state:
		intial_state.enter()
		current_state = intial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func on_child_transistion(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state
