extends Node2D
class_name SliderGate

export (Array, NodePath) var switches

onready var state_machine = $StateMachine
onready var gate = $Gate

# Called when the node enters the scene tree for the first time.
func _ready():
	_initialize()
	slide_gate_closed()

func _initialize() -> void:
	for i in range(switches.size()):
		var switch: Switch = get_node(switches[i])
		state_machine.switch_states.append(false)
		switch.connect("switched", state_machine, "_on_switched", [i])

func _on_finished(next_state_name):
	if next_state_name == "open":
		slide_gate_open()
	else:
		slide_gate_closed()

func slide_gate_open() -> void:
	gate.position.x = 47
	
func slide_gate_closed() -> void:
	gate.position.x = -47

func _play_animation(animation: String) -> void:
	pass
