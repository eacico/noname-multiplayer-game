extends Area2D


var players_won: Array = []


func _ready() -> void:
#	portal.play("idle")
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node) -> void:
	if  body is Player:
		if !players_won.has(body.id):
			players_won.append(body.id)
			#portal.play("open")
			#GameState.notify_level_won()
			GameState.notify_player_reached_goal(body.id)

