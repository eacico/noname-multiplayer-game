extends Node2D

onready var slider_gate_1 = $SliderGate1
onready var slider_gate_2 = $SliderGate2
onready var slider_gate_3 = $SliderGate3
onready var lava = $"../../Entities/Lava"

func trigger_reached(player, trigger_id: int):
	match trigger_id:
		1:
			slider_gate_1.set_open()
			slider_gate_2.set_closed()
		2:
			slider_gate_1.set_closed()
			slider_gate_3.set_open()
			lava.VELOCITY = 15
