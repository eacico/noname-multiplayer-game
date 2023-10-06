extends Control


signal restart_game()


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	GameState.connect("level_won", self, "_on_level_won")


func _on_level_won() -> void:
	show()
	
func _on_RestartButton_pressed():
	hide()
	emit_signal("restart_game")



func show() -> void:
	.show()
	get_tree().paused = true


func hide() -> void:
	.hide()
	get_tree().paused = false
