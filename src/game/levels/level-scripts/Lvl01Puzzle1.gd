extends Node2D

onready var slider_gate_2 = $SliderGate2
onready var slider_gate_3 = $SliderGate3

func trigger_reached(player, trigger_id: int):
	match trigger_id:
		2:
			slider_gate_2.set_closed()
		3:
			slider_gate_3.set_closed()
