class_name Entity
extends CharacterBody2D
signal entity_hit(entity : Entity)
signal entity_death(entity : Entity)

@export var maximum_health = 100.0
@onready var current_health = maximum_health
@export var entity_hurtbox : Hurtbox
@onready var entity_status_list = []
var is_immovable := false
var is_stunned := false
var is_slowed := false
var is_flying := false
var flying_hitbox = Hitbox.new()
@export_range(0.0, 100.0, 1.0,"prefer_slider") var entity_knockback_resistance := 0.0

func _ready() -> void:
	entity_hurtbox.connect("hurtbox_detection", damage, 1)
	setup_flying_hitbox()

func setup_flying_hitbox():
	flying_hitbox.hitbox_data = HitboxData.new()
	flying_hitbox.hitbox_data.damage = 0
	flying_hitbox.hitbox_data.knockback = 0
	flying_hitbox.set_collision_mask_value(2, true)
	flying_hitbox.set_collision_mask_value(3, true)
	add_child(flying_hitbox)
	var flying_hitbox_collision = CollisionShape2D.new()
	flying_hitbox.add_child(flying_hitbox_collision)
	flying_hitbox_collision.shape = CircleShape2D.new()
	flying_hitbox_collision.shape.radius = 15.0

func _physics_process(_delta: float) -> void:
	if is_immovable:
		return
	move_and_slide()
	flying_check()

func flying_check():
	flying_hitbox.is_hitbox_disabled = !is_flying
	if get_slide_collision_count() > 0 and is_flying:
		var wall_damage = HitboxData.new()
		wall_damage.damage = velocity.length() * 0.25
		wall_damage.knockback = 0.0
		damage(wall_damage)
		
		flying_hitbox.hitbox_data.damage = velocity.length() * 0.05
		print(flying_hitbox.hitbox_data.damage)
		flying_hitbox.hitbox_data.knockback = velocity.length() * 0.80
		
		velocity = velocity.bounce(get_slide_collision(0).get_normal())
		velocity *= 0.90
		if velocity.length() < 180.0:
			velocity = velocity.bounce(get_slide_collision(0).get_normal()) * 0.25
			flying_hitbox.is_hitbox_disabled = true
			is_flying = false

func damage(hitbox_data : HitboxData):
	current_health -= hitbox_data.damage
	
	if hitbox_data.effect_list.size() > 0:
		for effect in hitbox_data.effect_list:
			utility.apply_status_effect(effect, self, hitbox_data.effect_list[effect])
	
	if hitbox_data.knockback > 0:
		knockback(hitbox_data)
	
	if current_health <= 0.0:
		entity_death.emit(self)
		return
	elif current_health > 0.0:
		entity_hit.emit(self)

func knockback(hitbox_data : HitboxData) -> void:
	if self is Enemy:
		utility.apply_status_effect("Stunned", self, 0.3)
	
	if hitbox_data.knockback >= velocity.length() / 2:
		var knockback_velocity = self.position.direction_to(hitbox_data.position)
		velocity = knockback_velocity * hitbox_data.knockback
		
		if hitbox_data.knockback > 125.0:
			is_flying = true
			velocity *= 3.5
			velocity = velocity.limit_length(525)
		else:
			is_flying = false
			velocity = velocity.limit_length(125)
