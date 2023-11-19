extends Node

signal level_won()
signal game_over()
signal current_players_changed()
signal input_map_changed()


var players: Array = [] setget set_players
var players_in_goal: Array = []
var players_dead: Array = []

var player_colors: Array = [Color(0.92549, 0.717647, 0)
							,Color(0.533333, 0.776471, 0.364706)]


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

func set_players(_players: Array) -> void:
	players = _players
	for i in range(players.size()):
		if range(player_colors.size()).has(i):
			players[i].set_body_color(player_colors[i])
	emit_signal("current_players_changed")



func notify_input_map_changed() -> void:
	emit_signal("input_map_changed")
