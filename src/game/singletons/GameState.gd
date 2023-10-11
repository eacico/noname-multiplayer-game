extends Node

signal level_won()
signal game_over()


var players: Array = []
var players_in_goal: Array = []


func notify_player_reached_goal(player_id: String) -> void:
	print("notify_player_reached_goal("+player_id+")")
	if !players_in_goal.has(player_id):
		players_in_goal.append(player_id)
	
	if players.size() == players_in_goal.size():
		emit_signal("level_won")

func notify_player_death() -> void:
	emit_signal("game_over")
