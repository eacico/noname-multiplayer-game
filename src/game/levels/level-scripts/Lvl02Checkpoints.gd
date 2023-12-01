extends Node2D

onready var p_1 = $TriggerCheckpoint1/P1

func checkpoint_reached(player, checkpoint_id):
	GameState.checkpoint = [
		get_node("TriggerCheckpoint%s/P1" % [checkpoint_id]).global_position,
		get_node("TriggerCheckpoint%s/P2" % [checkpoint_id]).global_position
	]
