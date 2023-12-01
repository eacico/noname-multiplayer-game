extends Node2D
onready var bgm_manager = $"../BGM/BGMManager"


func _play_track(player, stream: AudioStream, db: float = 0.0, pitch: float = 1.0, xfade_time: float = 1.0):
	bgm_manager.play(stream, db, pitch, xfade_time)
