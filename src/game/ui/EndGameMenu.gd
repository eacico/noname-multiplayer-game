extends Control

signal restart_game()
signal goto_next_level()
signal goto_main_menu()

onready var next_level_button = $Panel/VBoxContainer/NextLevelButton


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	GameState.connect("level_won", self, "_on_level_won")
	GameState.connect("game_over", self, "_on_level_lost")


func _on_level_won() -> void:
	show()
	
func _on_level_lost() -> void:
	show()
	next_level_button.hide()


func _on_RestartButton_pressed():
	hide()
	emit_signal("restart_game")

func _on_NextLevelButton_pressed():
	hide()
	emit_signal("goto_next_level")

func _on_MainMenuButton_pressed():
	hide()
	emit_signal("goto_main_menu")
	

func show() -> void:
	.show()
	get_tree().paused = true


func hide() -> void:
	.hide()
	get_tree().paused = false


