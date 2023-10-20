extends Node

signal level_won()
signal game_over()


var players: Array = []
var players_in_goal: Array = []
var players_dead: Array = []


func notify_player_reached_goal(player_id: String) -> void:
	print("notify_player_reached_goal("+player_id+")")
	if !players_in_goal.has(player_id):
		players_in_goal.append(player_id)
	
	if players.size() == players_in_goal.size():
		emit_signal("level_won")

func notify_player_death(player: Player) -> void:
	print("notify_player_death("+player.id+")")
	if !players_dead.has(player.id):
		players_dead.append(player.id)
		
	if players.size() == players_dead.size():
		emit_signal("game_over")
	
func notify_player_respawn(player: Player) -> void:
	print("notify_player_respawn("+player.id+")")
	if players_dead.has(player.id):
		players_dead.erase(player.id)
	print("players muertos: %s" % [players_dead.size()])
