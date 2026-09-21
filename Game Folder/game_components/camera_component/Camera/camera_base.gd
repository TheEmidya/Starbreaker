extends Camera2D
class_name CameraController

@export_category("Zoom Variables")
@export_range(-10.0, 10.0, 0.1) var initial_zoom_value := 1.0
const DEFAULT_ZOOM_DURATION := 0.05

@export_category("Shake Variables")  
@export var maximum_shake_duration = 0.5
@onready var shake_strength := 0.0
@export var shake_decay := 0.7 ## Note; shake_decay will reduce the number by the percentage amount. IE - 100 Amplitude with 0.5 shake_decay will go down to 50, 25, 12.5, etc.
@export var anchor = Camera2D.ANCHOR_MODE_DRAG_CENTER


func _ready() -> void: 
	events.camera_shake.connect(shake, 1)
	events.camera_zoom.connect(impact_zoom, 3)
	events.camera_freezeframe.connect(freezeframe, 2)
	
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	self.zoom = Vector2(initial_zoom_value, initial_zoom_value)

func _physics_process(_delta: float) -> void:
	shake_process()

#region Zoom Functions
func impact_zoom(applied_zoom := 0.1, zoom_to := self.global_position, zoom_duration := DEFAULT_ZOOM_DURATION):
	if options.extra_vfx:
		# Sets the camera position to allow for zooming on a specified target.
		global_position = zoom_to
		
		# Starts the zoom function with the percentage calucation.
		zoom_start(applied_zoom_to_percentage(applied_zoom), zoom_duration)
		await get_tree().create_timer(zoom_duration).timeout
		zoom_reset()

func applied_zoom_to_percentage(applied_zoom) -> float:
	# Converts applied zoom value to percentage for consistentcy reasons.
	var applied_zoom_percentage = float(applied_zoom/initial_zoom_value) * 100
	return applied_zoom_percentage

func zoom_start(applied_zoom, zoom_duration := DEFAULT_ZOOM_DURATION):
	var maximum_zoom_amount = 6.5
	# Creates a Tween and changes the zoom amount.
	var zoom_tween = create_tween().set_parallel(true)
	zoom_tween.tween_property(self, 'zoom:x', clamp(zoom.x + applied_zoom, 0, maximum_zoom_amount), zoom_duration)
	zoom_tween.tween_property(self, 'zoom:y', clamp(zoom.y + applied_zoom, 0, maximum_zoom_amount), zoom_duration)
	await zoom_tween.finished
	zoom_tween.kill()

func zoom_reset(zoom_duration := DEFAULT_ZOOM_DURATION):
	# Creates another Tween and moves it in reverse to the default position.
	var reset_zoom_tween = create_tween().set_parallel(true)
	reset_zoom_tween.tween_property(self, 'zoom:x', initial_zoom_value, zoom_duration)
	reset_zoom_tween.tween_property(self, 'zoom:y', initial_zoom_value, zoom_duration)
	await reset_zoom_tween.finished
	reset_zoom_tween.kill()
	global_position = Vector2(320, 181)
#endregion
 
#region Screenshake Functions
func shake(amplitude := 1000.0): ## Adds a number to the shake strength.
	if options.screenshake_enabled:
		shake_strength = amplitude

func get_random_camera_offset() -> Vector2: ## Returns a random vector by the shake strength determined by the amplitude.
	return Vector2(randf_range(-shake_strength,  shake_strength), randf_range(-shake_strength, shake_strength))

func shake_process(): ## When the shake strength is above 0, it'll set the offset to the RNG offset. Slowly reducing the strength of the offset by decreasing the shake strength's decay.
	if not is_zero_approx(shake_strength):
		shake_strength = lerpf(shake_strength, 0, shake_decay)
		offset = get_random_camera_offset()
#endregion

#region Freezeframe Functions
func freezeframe(amount, duration): 
	Engine.time_scale = amount
	await get_tree().create_timer(duration * amount).timeout
	Engine.time_scale = 1.0
#endregion

func true_freeze(amount):
	OS.delay_usec(amount)
