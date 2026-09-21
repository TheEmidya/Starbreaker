extends Entity
class_name Enemy
@export var enemyscore_hit := 250
@export var enemyscore_death := 1000

@export var display_healthbar := true
@export var healthbar_y_offset := 0.0
const ENEMY_HEALTHBAR = preload("uid://dpao1b3klbe5x")
@onready var enemy_healthbar := ENEMY_HEALTHBAR.instantiate()

@onready var hitflash_effect := self.material


@export var ai_navigation : NavigationAgent2D
@onready var player_direction := Vector2.ZERO:
	get:
		return self.global_position.direction_to(global.player.global_position)

func _ready() -> void:
	super()
	setup_enemy_healthbar()

func setup_enemy_healthbar():
	add_child(enemy_healthbar)
	enemy_healthbar.y_offset += healthbar_y_offset
