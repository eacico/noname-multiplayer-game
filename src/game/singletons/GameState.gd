extends Node

signal level_won()
signal game_over()
signal current_players_changed()
signal input_map_changed()


var players: Array = [] setget set_players
var players_in_goal: Array = []
var players_dead: Array = []
var checkpoint: Array = []

var player_palette: Array = [Color(0.92549, 0.717647, 0)
							,Color(0.533333, 0.776471, 0.364706)]


func notify_player_reached_goal(player_id: String) -> void:
	print("notify_player_reached_goal("+player_id+")")
	if !players_in_goal.has(player_id):
		players_in_goal.append(player_id)
	
	if players.size() == players_in_goal.size():
		emit_signal("level_won")
	elif players.size() == (players_dead.size() + players_in_goal.size()):
		emit_signal("game_over")

func notify_player_death(player) -> void:
	print("notify_player_death("+player.id+")")
	if !players_dead.has(player.id):
		players_dead.append(player.id)
		
		for p in players:
			if p != player:
				p.set_ghost_to_help(player)
		
	if players.size() == (players_dead.size() + players_in_goal.size()):
		emit_signal("game_over")
	
func notify_player_respawn(player) -> void:
	print("notify_player_respawn("+player.id+")")
	if players_dead.has(player.id):
		players_dead.erase(player.id)
		
	for p in players:
		p.set_ghost_to_help(null)
		
	print("players muertos: %s" % [players_dead.size()])

func set_players(_players: Array) -> void:
	players = _players
	for i in range(players.size()):
		if range(player_palette.size()).has(i):
			players[i].set_body_color(player_palette[i])
	emit_signal("current_players_changed")

func change_player_palette(player_id: String, color: Color):
	var player_position = get_player_array_position(player_id)
	if player_position >= 0:
		player_palette[player_position] = color
		players[player_position].set_body_color(color)
	elif int(player_id):
		player_palette[int(player_id) - 1] = color

func get_player_palette(player_id: String) -> Color:
	var player_position = get_player_array_position(player_id)
	if player_position >= 0:
		return player_palette[player_position]
	elif int(player_id):
		return player_palette[int(player_id) - 1]
	return Color.white

func get_player_array_position(player_id: String) -> int:
	if players != null:
		for i in range(players.size()):
			if is_instance_valid(players[i]) and players[i].id == player_id:
				return i
	return -1


func notify_input_map_changed() -> void:
	emit_signal("input_map_changed")
