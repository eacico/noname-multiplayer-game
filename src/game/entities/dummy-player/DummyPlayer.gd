extends Node2D
class_name DummyPlayer

onready var body_color = $"%ColorSprite"
onready var body_animations = $BodyAnimations

export (Color) var color: Color = Color.white


func _ready():
	_play_animation("idle")
	body_color.modulate = color



func set_body_color(_color: Color):
	color = _color
	if body_color:
		body_color.modulate = _color


func _play_animation(animation: String) -> void:
	if body_animations.has_animation(animation) and body_animations.get_assigned_animation() != animation:
		body_animations.play(animation)
	if !body_animations.has_animation(animation):
		print("animation not found: '%s'." % [animation])
