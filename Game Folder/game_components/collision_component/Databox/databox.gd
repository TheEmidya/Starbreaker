extends Area2D
class_name Databox
signal on_parent_hit(colliding_hitbox, damage_taken)
signal on_parent_death(colliding_hitbox, damage_taken)

signal PlayerTeamHurtbox_entered(area : Databox)
signal NeutralTeamHurtbox_entered(area : Databox)
signal EnemyTeamHurtbox_entered(area : Databox)

signal PlayerTeamHitbox_entered(area : Databox)
signal NeutralTeamHitbox_entered(area : Databox)
signal EnemyTeamHitbox_entered(area : Databox)

signal is_taking_knockback(duration : float)

@export_category("Affiliations")
@export var parent : CharacterBody2D
@export_enum("PlayerTeam", "NeutralTeam", "EnemyTeam") var team_affiliation = "NeutralTeam"

@export_category("Databox Data")
@export_subgroup("Global Data")
@export_enum("Hurtbox", "Hitbox") var databox_type = "Hitbox"
@export var is_disabled := false

@export_subgroup("Hitbox Data")
@export var damage := 0.0
@export var knockback_amount := 0.0
@export var knockback_stun_duration : float = 0.0

@export_subgroup("Hurtbox Data")
@export var max_health := 100
@onready var health := max_health
@export var recieves_knockback := true
@export var is_knockback_forced_upwards := true
@export_range(0.0, 1.0) var armor_multiplier := 1.0
@onready var knockback_timer := Timer.new()
@onready var knockback_direction := Vector2.ZERO
@onready var latest_knockback_amount := 0.0

@export_category("Crosshair Data")
@export var lockin_size = 1.0
@export var can_be_locked_in = false
var is_locked_in = false

#region Godot Functions
func _ready() -> void:
	connect("area_entered", area_entered, 1)
	knockback_setup()

func _physics_process(delta: float) -> void:
	matching_databox_type()
	#update_hitbox_data_process()
	check_knockback_process(delta)
#endregion

func _process(_delta: float) -> void:
	check_disable_mode_process()

#region Runtime Checks
func matching_databox_type(): ## Match databox type to sets of variable changes.
	match databox_type:
		"Hitbox":
			change_debug_color(Color.RED)
		"Hurtbox":
			change_debug_color(Color.AQUA)

func change_debug_color(color): ## Changes the debug color of the databox collisions.
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = color
			child.debug_color.a = 0.1
		if child is CollisionPolygon2D:
			pass

## Checks the disable mode for the databox. Appropriately changing the state depending on the is_disabled value.
func check_disable_mode_process():
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = is_disabled
		if child is CollisionPolygon2D:
			child.disabled = is_disabled


### Aligns the hitbox data to the current stats of the databox.
#func update_hitbox_data_process():
	#hitbox_data.team_affiliation = team_affiliation
	#hitbox_data.damage = damage
	#hitbox_data.knockback_amount = knockback_amount
	#hitbox_data.knockback_stun_duration = knockback_stun_duration
	### Warns the developer that the data isn't local, causing possible bugs and unintended side effects.
	##if is_instance_valid(hitbox_data) and damage > 0:
		##if hitbox_data.resource_local_to_scene == false:
			##printerr(var_to_str(parent.name) + var_to_str(self.name) + " doesn't have hitbox data local to it's scene!")
#endregion

#region Hitbox / Hurtbox Reaction
## Hitbox & Hurtbox reactions based on team affiliation.
func area_entered(area: Area2D) -> void:
	if area is Databox:
		if area.databox_type == "Hurtbox": ## Hurtboxes are recievers and do not aggress onto Hitboxes. 
			match area.team_affiliation:
				"PlayerTeam":
					emit_signal("PlayerTeamHurtbox_entered", area)
				"NeutralTeam":
					emit_signal("NeutralTeamHurtbox_entered", area)
				"EnemyTeam":
					emit_signal("EnemyTeamHurtbox_entered", area)
		if area.databox_type == "Hitbox": ## Hitboxes are the agressors. Telling the game when they overlap with a hurtbox and letting the hurtbox recieve the data and handle it.
			match area.team_affiliation:
				"PlayerTeam":
					emit_signal("PlayerTeamHitbox_entered", area)
				"NeutralTeam":
					emit_signal("NeutralTeamHitbox_entered", area)
				"EnemyTeam":
					emit_signal("EnemyTeamHitbox_entered", area)

#endregion

func take_damage(colliding_hitbox : Databox):
	var damage_taken = colliding_hitbox.damage
	health = clamp(health - damage_taken, 0, max_health)
	calculate_knockback(colliding_hitbox)
	if !parent.has_method("on_parent_hit"):
		push_error(str(parent.name) + " didn't have a method called on_parent_hit")
	if !parent.has_method("on_parent_death"):
		push_error(str(parent.name) + " didn't have a method called on_parent_death")
	if health <= 0:
		if parent.has_method("on_parent_death"):
			parent.call("on_parent_death", colliding_hitbox, damage_taken)
	else:
		if parent.has_method("on_parent_hit"):
			parent.call("on_parent_hit", colliding_hitbox, damage_taken)
#region Knockback Reactions
# Higher knockback amounts and lower stun duration results in a snappier knockback effect.
# Lower knockback amounts and higher stun durations are good a long knockback effect.

func knockback_setup():
	knockback_timer.one_shot = true
	add_child(knockback_timer)

func calculate_knockback(colliding_hitbox : Databox):
	## Grabs the knockback data from ther colliding hitbox.
	latest_knockback_amount = colliding_hitbox.knockback_amount
	knockback_direction = colliding_hitbox.global_position.direction_to(parent.global_position)
	## Starts the timer using the knockback duration.
	knockback_stun_duration = colliding_hitbox.knockback_stun_duration
	knockback_timer.start(knockback_stun_duration)
	emit_signal("is_taking_knockback", knockback_stun_duration)


func apply_knockback(delta):
	## New knockback variables to consolidate the data.
	var knockback_velocity = Vector2.ZERO
	var knockback_scalar = 3.0
	## Multiplies the knockback direction to the amount.
	knockback_velocity = knockback_direction * latest_knockback_amount
	## Makes sure the knockback always sends upwards.
	if is_knockback_forced_upwards:
		knockback_velocity.y = -abs(knockback_velocity.y) * 1.3
		knockback_velocity.x /= 2.5
	## Applies the vector.
	parent.velocity = knockback_velocity * delta
	
	parent.move_and_slide()
	## Multiplies the knockback amount to the time left on the timer to create a smoothing effect.
	latest_knockback_amount *= knockback_timer.time_left * knockback_scalar * armor_multiplier

func check_knockback_process(delta):
	if knockback_timer.time_left > 0 and recieves_knockback == true:
		apply_knockback(delta)
#endregion
