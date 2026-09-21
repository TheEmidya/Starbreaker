extends Node
class_name Weapon
@onready var player = get_parent().get_parent() as Player
@onready var is_weapon_actionable : bool = true
@onready var cooldown_timer : Timer = Timer.new()
@export_flags_2d_physics var raycast_mask


func _ready() -> void:
	setup()

func setup():
	cooldown_timer.one_shot = true
	cooldown_timer.autostart = false
	cooldown_timer.ignore_time_scale = false
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(func(): is_weapon_actionable = false, 0)

func action():
	pass

func raycast(cast_to : Vector2):
	var space = player.get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space)
	var query = PhysicsShapeQueryParameters2D.new()
	
	query.shape = RectangleShape2D.new()
	query.shape.size = Vector2(10, 10)
	query.motion = cast_to
	query.collision_mask = raycast_mask
	query.collide_with_areas = true
	
	var result = space_state.intersect_shape(query, 32)
	if result:
		return result
	else:
		return null
