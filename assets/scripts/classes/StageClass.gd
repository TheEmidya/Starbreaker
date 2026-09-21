extends Node2D
class_name StageClass
signal stage_started

var is_stage_active = false
var is_boss_active = false
@export var skip_intro = false

var player = preload("uid://tqr4d3yf0u5c")
var introvisuals_packed = preload("res://assets/scenes/misc/stage/stage_introvisuals.tscn")
@onready var intro_visuals = load_intro() as CanvasLayer

@export var music_file : AudioStream
@onready var music_player := AudioStreamPlayer.new()

func _ready() -> void:
	load_player()
	load_music()
	load_camera()
	
	DiscordRPC.details = "Playing " + name.capitalize()
	DiscordRPC.refresh()
	
	_intro(skip_intro)

func load_player():
	var _player_packed = player.instantiate() as PlayerEntityClass
	add_child(_player_packed)
	_player_packed.entity_movement_class.entity_is_immovable = true
	self.connect("stage_started", func(): _player_packed.entity_movement_class.entity_is_immovable = false, 0)
	_player_packed.global_position = get_viewport_rect().size / 2

func load_music():
	add_child(music_player)
	music_player.stream = music_file
	music_player.bus = "Music"

func load_intro():
	var _intro_visuals = introvisuals_packed.instantiate()
	add_child(_intro_visuals)
	return _intro_visuals as CanvasLayer

func load_camera():
	var stage_camera = Camera2D.new()
	stage_camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	add_child(stage_camera)

func _intro(_skip_intro : bool):
	match _skip_intro:
		false:
			intro_visuals.animation_player.play("int")
			
			await intro_visuals.animation_player.animation_finished
			
			intro_visuals.queue_free()
		true:
			intro_visuals.animation_player.play("skip_int")
			
			await intro_visuals.animation_player.animation_finished
			
			intro_visuals.queue_free()

func start_stage():
	is_stage_active = true
	stage_started.emit()
	music_player.play()
