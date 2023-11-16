extends Area2D

onready var tumbler_sfx = $TumblerSFX
onready var filler = $Sprite/Filler

export (float) var VELOCITY:float = 10.0 setget set_velocity

var direction:Vector2 = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")


func _physics_process(delta):
	position += direction * VELOCITY * delta
	filler.polygon[2] -= (direction * VELOCITY * delta)/4
	filler.polygon[3] -= (direction * VELOCITY * delta)/4
	


func _on_body_entered(body):
	if body is Player && body.has_method("notify_death"):
		print("Player " + body.id + " pierde!!")
		body.notify_death()


func set_velocity(_velocity:float) -> void:
	VELOCITY = _velocity
	if VELOCITY > 0:
		tumbler_sfx.play()
