extends Node

signal level_won()
signal game_over()


func notify_level_won() -> void:
	emit_signal("level_won")

func notify_player_death() -> void:
	emit_signal("game_over")
