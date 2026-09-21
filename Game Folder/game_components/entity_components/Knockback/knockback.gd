extends Node  # Inherit from Node2D
class_name KnockbackComponent  # Custom class name for better clarity

signal is_taking_knockback(duration : float)  # Signal for when knockback is happening

@export var parent : Node2D  # Reference to the parent node
@onready var latest_knockback_amount := 0.0  # Latest knockback amount applied
@onready var latest_knockback_stun_duration : float = 0.0  # Duration of the knockback stun
@export var recieves_knockback := true  # Whether the object can receive knockback
@export var is_knockback_forced_upwards := true  # Whether knockback is forced upwards
@onready var knockback_timer := Timer.new()  # Timer to track knockback duration
@onready var knockback_direction := Vector2.ZERO  # Knockback direction vector
@export_range(0.0, 1.0) var armor_multiplier := 1.0  # Multiplier for knockback resistance (armor)

func _ready() -> void:
	knockback_setup()  # Initialize knockback-related setup

#region Knockback Reactions

# Function to set up the knockback timer and related configurations
func knockback_setup() -> void:
	knockback_timer.one_shot = true  # Timer triggers only once
	add_child(knockback_timer)  # Add the timer to the node

# Function to calculate knockback when a collision occurs
func calculate_knockback(colliding_hitbox : HitboxComponent) -> void:
	print("knockback")
	# Set the knockback amount and direction from the hitbox
	latest_knockback_amount = colliding_hitbox.knockback_amount
	knockback_direction = colliding_hitbox.global_position.direction_to(parent.global_position)
	# Set the stun duration from the hitbox and start the knockback timer
	latest_knockback_stun_duration = colliding_hitbox.knockback_stun_duration
	knockback_timer.start(latest_knockback_stun_duration)
	emit_signal("is_taking_knockback", latest_knockback_stun_duration)  # Emit signal for knockback start

# Function to apply knockback effects based on delta time
func apply_knockback(delta : float) -> void:
	var knockback_velocity = Vector2.ZERO  # Initialize the knockback velocity
	var knockback_scalar = 3.0  # Scalar multiplier for knockback intensity
	# Calculate the knockback velocity based on direction and amount
	knockback_velocity = knockback_direction * latest_knockback_amount
	# Optionally apply upwards adjustment if forced upwards
	if is_knockback_forced_upwards:
		knockback_velocity.y = -abs(knockback_velocity.y) * 1.3  # Ensure upwards knockback
		knockback_velocity.x /= 2.5  # Reduce horizontal knockback component
	# Apply the calculated knockback velocity to the parent node
	parent.velocity = knockback_velocity * delta

	# Reduce the knockback amount based on the time left and armor multiplier
	latest_knockback_amount *= knockback_timer.time_left * knockback_scalar * armor_multiplier

# Function to check and apply knockback every physics frame
func check_knockback_process(delta : float) -> void:
	if knockback_timer.time_left > 0 and recieves_knockback:
		apply_knockback(delta)  # Apply knockback if conditions are met

#endregion  # End of Knockback Reactions
