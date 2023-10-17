extends Area2D


export (float) var VELOCITY:float = 10.0

var direction:Vector2 = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")


func _physics_process(delta):
	position += direction * VELOCITY * delta
	


func _on_body_entered(body):
	if body is Player && body.has_method("notify_death"):
		print("Player " + body.id + " pierde!!")
		body.notify_death()

