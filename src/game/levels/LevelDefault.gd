extends Node
class_name GameLevel

onready var player_1 = $Environment/Entities/Player1
onready var player_2 = $Environment/Entities/Player2


# Regresa al menu principal
signal main_menu_requested()
# Reinicia el nivel
signal restart_requested()
# Inicia el siguiente nivel
signal next_level_requested()


func _ready() -> void:
	GameState.players = [player_1.id, player_2.id]
	randomize()


# Funciones que hacen de interfaz para las señales
func _on_level_won() -> void:
	emit_signal("next_level_requested")


func _on_restart_requested() -> void:
	emit_signal("restart_requested")

func _on_goto_next_level_requested() -> void:
	emit_signal("next_level_requested")
	
func _on_goto_main_menu_requested() -> void:
	emit_signal("main_menu_requested")
