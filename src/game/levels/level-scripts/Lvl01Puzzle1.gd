extends Node2D

onready var slider_gate_2 = $SliderGate2
onready var slider_gate_3 = $SliderGate3
onready var players_in_checkpoint1 = []
onready var bgm_manager = $"../../../BGM/BGMManager"

func trigger_reached(player, trigger_id: int):
	match trigger_id:
		2:
			slider_gate_2.set_closed()
			if !players_in_checkpoint1.has(player.id):
				players_in_checkpoint1.append(player.id)
				if players_in_checkpoint1.size() == 2:
					bgm_manager.play("res://assets/sound/bgm/Tracks/Ambience 1.ogg",-5,1,5)
		3:
			slider_gate_3.set_closed()
			if !players_in_checkpoint1.has(player.id):
				players_in_checkpoint1.append(player.id)
				if players_in_checkpoint1.size() == 2:
					bgm_manager.play("res://assets/sound/bgm/Tracks/Ambience 1.ogg",-5,1,5)
	
