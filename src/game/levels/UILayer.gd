extends CanvasLayer

onready var end_game_menu = $EndGameMenu

func _ready():
	end_game_menu.get_node("Panel/VBoxContainer/NextLevelButton").disabled = true
