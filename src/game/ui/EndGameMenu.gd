extends Control

signal restart_game()
signal goto_next_level()
signal goto_main_menu()
signal retry_level()

onready var next_level_button = $Panel/VBoxContainer/NextLevelButton
onready var retry_button = $Panel/VBoxContainer/RetryButton
onready var label = $Panel/Label

export (bool) var is_last_level: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	GameState.connect("level_won", self, "_on_level_won")
	GameState.connect("game_over", self, "_on_level_lost")


func _on_level_won() -> void:
	label.text = "Success"
	next_level_button.disabled = is_last_level
	next_level_button.show()
	retry_button.hide()
	show()
	
func _on_level_lost() -> void:
	label.text = "Game Over"
	next_level_button.hide()
	retry_button.show()
	show()


func _on_RestartButton_pressed():
	hide()
	emit_signal("restart_game")

func _on_NextLevelButton_pressed():
	hide()
	emit_signal("goto_next_level")

func _on_MainMenuButton_pressed():
	hide()
	emit_signal("goto_main_menu")
	
func _on_RetryButton_pressed():
	hide()
	emit_signal("retry_level")


func show() -> void:
	.show()
	get_tree().paused = true
	if next_level_button.visible:
		next_level_button.grab_focus()
	else:
		retry_button.grab_focus()


func hide() -> void:
	.hide()
	get_tree().paused = false




