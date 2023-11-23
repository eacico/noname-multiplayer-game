extends Node2D

onready var slider_gate_1 = $SliderGate1
onready var slider_gate_2 = $SliderGate2
onready var lava = $"../../Entities/Lava"

func trigger_reached(player, trigger_id: int):
	match trigger_id:
		1:
			slider_gate_1.slide_gate_open()
			slider_gate_2.slide_gate_closed()
		2:
			slider_gate_1.slide_gate_closed()
			lava.VELOCITY = 15
