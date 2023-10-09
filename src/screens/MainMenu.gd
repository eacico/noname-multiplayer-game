extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action("reset"):
		restart_game()


func _on_EndGameMenu_restart_game():
	restart_game()

func restart_game():
	print("restart")
	get_tree().reload_current_scene()
