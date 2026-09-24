extends EntityClass
class_name PlayerEntityClass
signal player_enter_focus()
signal player_exit_focus()

@onready var entity_movement_class: EntityMovementClass = %EntityMovementClass
@onready var entity_health_class: EntityHealthClass = %EntityHealthClass
@onready var player_weapon: Node2D = $PlayerSprayWeapon

@onready var crosshair: AnimatedSprite2D = %Crosshair
@onready var ui_charge_meter: TextureProgressBar = %ui_charge_meter


@export var mouse_turn_weight = 12.0
@export var crosshair_smoothing = 15.0
@export var focus_mode_multiplier = 2.0

func _enter_tree() -> void:
	global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _exit_tree() -> void:
	global.player = null

func _physics_process(delta: float) -> void:
	look_toward_mouse(delta)
	crosshair_update(delta)
	entity_movement_class.move(Input.get_vector("move_left", "move_right", "move_up", "move_down"), delta)

func _process(_delta: float) -> void:
	weapon_input_handler()
	focus_mode_handler()

func crosshair_update(delta : float):
	if entity_movement_class.entity_is_immovable:
		return
	
	crosshair.global_position = lerp(crosshair.global_position, get_global_mouse_position(), 12.0 * delta)

func look_toward_mouse(delta : float):
	if entity_movement_class.entity_is_immovable:
		return
	
	var final_mouse_pos = (crosshair.global_position - global_position).angle()
	self.rotation = lerp_angle(self.rotation, final_mouse_pos, mouse_turn_weight * delta)


func focus_mode_handler():
	if Input.is_action_just_pressed("slow"):
		player_enter_focus.emit()
		$Sprite.hide()
		entity_multipliers.speed_multiplier /= focus_mode_multiplier
	if Input.is_action_just_released("slow"):
		$Sprite.show()
		player_exit_focus.emit()
		entity_multipliers.speed_multiplier *= focus_mode_multiplier

func weapon_input_handler():
	if entity_movement_class.entity_is_immovable:
		return
	
	if Input.is_action_pressed("primary"):
		player_weapon.primary_fire_current_weapon()
	
	if Input.is_action_pressed("secondary"):
		player_weapon.secondary_fire_current_weapon()
