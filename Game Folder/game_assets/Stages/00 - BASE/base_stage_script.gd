extends Node2D
class_name StageBase
signal stage_ended()

const ENEMY_NAVIGATIONSPACE = preload("res://Game Folder/game_assets/Stages/00 - BASE/navigation_space.tscn")
const WALL_COLLISIONS = preload("res://Game Folder/game_assets/Stages/00 - BASE/lvl_manager/walls/wall_collisions.tscn")
const PLAYER = preload("res://Game Folder/game_assets/Player/Main/Player.tscn")

var navigation_space = ENEMY_NAVIGATIONSPACE.instantiate()
var wall_collision = WALL_COLLISIONS.instantiate()
var player = PLAYER.instantiate()

var stage_current_score : float = 0.0
var stage_time_score : float = 0.0

var stage_camera = CameraController.new()
@onready var stage_enemy_ai = ENEMY_NAVIGATIONSPACE.instantiate()
@onready var stage_music := AudioStreamPlayer.new()
@export var stage_music_file : AudioStreamMP3
@onready var stage_boss_music := AudioStreamPlayer.new()
const STAGE_TIME_SCORE = 25000.0

@onready var stage_started = false
@onready var stage_current_time = 0.0: 
	get: return stage_music.get_playback_position()
@onready var stage_endtime := 0.0:
	get: return stage_music.stream.get_length()

@export var enemy_wave_data : Dictionary[float, StageEnemyData] = {}


# Extra ARG
@onready var is_spawning = true
const PLAYER_SPAWN_POSITION = Vector2(320, 290)

func _init() -> void:
	add_child(wall_collision, true)
	add_child(navigation_space, true)
	add_child(stage_music, true)
	add_child(stage_camera, true)
	add_child(stage_enemy_ai, true)

func _ready() -> void:
	player_setup(player)
	music_setup(stage_music_file)

func _physics_process(_delta: float) -> void:
	spawn_enemy_wave(enemy_wave_data)
	stage_time_score = remap(stage_current_time, 0.0, stage_endtime, 0.0, STAGE_TIME_SCORE)

func player_setup(PlayerScene : Player):
	PlayerScene.global_position = PLAYER_SPAWN_POSITION
	PlayerScene.current_life_counter = global.life_counter
	add_child(player)

func spawn_enemy_wave(data : Dictionary[float, StageEnemyData]):
	if data.has(roundf(stage_current_time)):
		if data[roundf(stage_current_time)].has_spawned == false:
			data[roundf(stage_current_time)].has_spawned = true
			printt(data[roundf(stage_current_time)].enemy_scene.resource_name, roundf(stage_current_time))
			
			var enemy = data[roundf(stage_current_time)].enemy_scene.instantiate() as Node2D
			enemy.global_position = data[roundf(stage_current_time)].enemy_spawn_location
			add_child(enemy)

func music_setup(StageMusicMP3 : AudioStreamMP3):
	add_child(stage_music)
	stage_music.stream = StageMusicMP3
	stage_endtime = stage_music.stream.get_length()
	stage_music.play()
	stage_music.finished.connect(func(): stage_ended.emit())
