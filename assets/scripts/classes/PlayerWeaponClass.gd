extends Node2D
class_name PlayerWeaponClass

@export var player_entity : PlayerEntityClass
@export var current_weapon_name = "SPRAY"
@export var bullet_uid := "uid://ce0k7ggqwaxbd"

func _ready() -> void:
	setup_weapons()

func setup_weapons():
	pass

func load_bullet(_bullet_uid) -> ProjectileClass:
	var _bullet_loadpath = load(_bullet_uid) as PackedScene
	var _bullet_int = _bullet_loadpath.instantiate()
	return _bullet_int as ProjectileClass

func primary_fire_current_weapon():
	print('FIRE!')

func secondary_fire_current_weapon():
	print('FIRE! (2)')
