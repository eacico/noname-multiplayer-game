extends Area2D


var won: bool = false


func _ready() -> void:
#	portal.play("idle")
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node) -> void:
	if !won && body is Player:
		print("You win!")
		won = true
#		portal.play("open")
		GameState.notify_level_won()

