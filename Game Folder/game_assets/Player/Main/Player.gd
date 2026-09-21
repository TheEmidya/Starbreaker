extends Entity
class_name Player
@export var current_life_counter = 3
const GAMEOVER_PATH = preload("res://Game Folder/game_assets/Player/HUD/gameover.tscn")

func hurtbox_detection(hitbox: Hitbox) -> void:
	knockback(hitbox.hitbox_data)
