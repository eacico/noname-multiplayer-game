extends Node

signal level_won()

func notify_level_won() -> void:
	emit_signal("level_won")
