extends Node2D

onready var slider_gate_entrance_1 = $Start/SliderGate_entrance1
onready var slider_gate_start_2 = $Start/SliderGate_start2
onready var slider_gate_start_3 = $Start/SliderGate_start3
onready var players_in_mid_section = []
onready var bgm_manager = $"../../../BGM/BGMManager"
onready var action_track = preload("res://assets/sound/bgm/Tracks/Action 1.ogg")
onready var lava_2 = $"../../Entities/Lava2"


func trigger_reached(player, trigger_id: int):
	match trigger_id:
		1:
			slider_gate_start_2.set_open()
			if !players_in_mid_section.has(player.id):
				players_in_mid_section.append(player.id)
				if players_in_mid_section.size() == 2:
					_start_lava_rising()
		2:
			slider_gate_start_3.set_open()
			if !players_in_mid_section.has(player.id):
				players_in_mid_section.append(player.id)
				if players_in_mid_section.size() == 2:
					_start_lava_rising()

func _start_lava_rising():
	bgm_manager.play(action_track,-10,1,2)
	lava_2.VELOCITY = 15
	slider_gate_entrance_1.set_open()

func _play_track(player, stream: AudioStream, db: float = 0.0, pitch: float = 1.0, xfade_time: float = 1.0):
	bgm_manager.play(stream, db, pitch, xfade_time)

