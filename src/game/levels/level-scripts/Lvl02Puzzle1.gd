extends Node2D

onready var player_1 = $"%Player1"
onready var player_2 = $"%Player2"

func _ready() -> void:
	player_1.connect("dead", self, "_on_player_dead", [player_1])
	player_2.connect("dead", self, "_on_player_dead", [player_2])

func _on_player_dead(player: Player) -> void:
	if GameState.checkpoint.size() == 0:
		GameState.emit_signal("game_over")
