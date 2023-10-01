extends Sprite


export (float) var VELOCITY:float = 10.0

var direction:Vector2 = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position += direction * VELOCITY * delta
	


func _on_DamageBox_body_entered(body):
	if body.has_method("notify_death"):
		body.notify_death()
