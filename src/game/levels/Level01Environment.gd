extends Node2D

onready var start_gate = $Entities/StartGate
onready var lava = $Entities/Lava

var players_on_start: Array

func _ready():
	players_on_start = []


func _players_reached_start(body):
	if body is Player and !players_on_start.has(body.id):
		players_on_start.append(body.id)
		
	if players_on_start.size() == GameState.players.size():
		start_gate.slide_gate_open()
		lava.VELOCITY = 15
