extends Node


var score := 0
var high_score := 0
var level_scoremanager = null
var score_display = null
var combo_multiplier = 1.0

signal score_update(amount)

func update_score(amount):
	add_up_to_score(amount)
	emit_signal("score_update", amount)

func passive_score_update(amount, delta):
	update_score(amount * delta)

func add_up_to_score(addition_threshold):
	for i in range(addition_threshold):
		score += 1
		await get_tree().create_timer(0.07, false, true, false).timeout
		if score == addition_threshold:
			break

func get_score_position() -> Vector2:
	if level_scoremanager:
		return level_scoremanager.positional_coords.global_position
	else:
		return Vector2.ZERO

func _ready() -> void:
	cache.load_in_cache("res://Game Folder/game_components/global_components/Damage Display/DamageDisplay.tscn")

func _physics_process(delta: float) -> void:
	if global.paused == false:
		passive_score_update(250, delta)

func _process(_delta: float) -> void:
	if is_instance_valid(score_display):
		score_display.text = str(score)

func display_damage(amount : int, target : Node2D):
	var damagedisplay = load("res://Game Folder/game_components/global_components/Damage Display/DamageDisplay.tscn")
	var dd_int = damagedisplay.instantiate() as Label
	global.EntityManager.add_child(dd_int)
	dd_int.text = str(amount)
	dd_int.global_position = target.global_position
