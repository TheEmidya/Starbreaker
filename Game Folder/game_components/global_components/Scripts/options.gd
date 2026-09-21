extends Node

var HasSeenIntro : bool = false


var screenshake_enabled : bool = true
var screen_flash : bool = true
var displaydamage_enabled : bool = true
var extra_vfx : bool = true
var bloom = 0.5
var crosshair_enabled := true



func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_ready()
