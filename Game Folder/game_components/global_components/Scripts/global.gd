extends Node

var player : PlayerEntityClass = null




var crosshair = null
var player_gui = null
var camera = null
var life_counter : int = 3

var main_manager = null
var fun_value = randi_range(0, 255):
	get:
		randomize()
		print(fun_value)
		return randi_range(0, 255)

var boss_healthbar = null

var current_stage = null
var current_stage_score := 0
var last_stage_selected = null
var EntityManager = null

var music_player = null

var button_audio = AudioStreamPlayer.new()

var lvl_manager = null
var has_viewed_tutorial = false

var is_pausable = false
var paused = false

var projectile_z_index = 4000

static func spawn_entity(path : PackedScene) -> Node:
	var path_instaniated = path.instantiate()
	global.EntityManager.add_child(path_instaniated)
	return path_instaniated

func clear_enemies():
	if is_instance_valid(current_stage):
		for i in global.EntityManager.get_children():
			if i is Enemy:
				if i.is_active == true:
					i.queue_free()
			if i is Projectile:
				i.queue_free()
			if i is Timer:
				if i.is_stopped() == false:
					i.queue_free()
