extends Node2D

onready var start_gate = $Entities/StartGate
onready var lava = $Entities/Lava
onready var bgm_manager = $"../BGM/BGMManager"
onready var action_track = preload("res://assets/sound/bgm/Tracks/Action 1.ogg")

var players_on_start: Array

func _ready():
	players_on_start = []


func _players_reached_start(body):
	if body is Player and !players_on_start.has(body.id):
		players_on_start.append(body.id)
		
	if players_on_start.size() == GameState.players.size():
		start_gate.slide_gate_open()
		lava.VELOCITY = 15
		bgm_manager.play(action_track, -10.0, 1.0, 2.0)

func _play_track(player, stream: AudioStream, db: float = 0.0, pitch: float = 1.0, xfade_time: float = 1.0):
	bgm_manager.play(stream, db, pitch, xfade_time)
