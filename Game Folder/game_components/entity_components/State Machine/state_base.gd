extends Node
class_name State

@export var parent : Node
@export var is_state_cancelable := true

signal Transistioned

func enter():
	pass

func exit():
	pass

func update(_delta):
	pass

func physics_update(_delta):
	pass
