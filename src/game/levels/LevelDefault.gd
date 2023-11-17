extends Node
class_name GameLevel

onready var player_1 = $"%Player1"
onready var player_2 = $"%Player2"


# Regresa al menu principal
signal main_menu_requested()
# Reinicia el nivel
signal restart_requested()
# Inicia el siguiente nivel
signal next_level_requested()


func _ready() -> void:
	GameState.players = [player_1, player_2]
	player_1.connect("dead", self, "_on_player_dead", [player_1])
	player_1.connect("respawn", self, "_on_player_respawn", [player_1])
	player_2.connect("dead", self, "_on_player_dead", [player_2])
	player_2.connect("respawn", self, "_on_player_respawn", [player_2])
	randomize()


func _on_restart_requested() -> void:
	emit_signal("restart_requested")

func _on_goto_next_level_requested() -> void:
	emit_signal("next_level_requested")
	
func _on_goto_main_menu_requested() -> void:
	emit_signal("main_menu_requested")
	
func _on_player_dead(player: Player) -> void:
	#player.hide()
	pass
	
func _on_player_respawn(player: Player) -> void:
	print("_on_player_respawn")
