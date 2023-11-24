extends Node
class_name GameLevel

onready var player_1 = $"%Player1"
onready var player_2 = $"%Player2"


# Regresa al menu principal
signal main_menu_requested()
# Reinicia el nivel
signal restart_requested()
# Inicia el siguiente nivel
signal next_level_requested()
signal retry_level_requested()


func _ready() -> void:
	GameState.players = [player_1, player_2]
	load_checkpoint()
	player_1.connect("dead", self, "_on_player_dead", [player_1])
	player_1.connect("respawn", self, "_on_player_respawn", [player_1])
	player_2.connect("dead", self, "_on_player_dead", [player_2])
	player_2.connect("respawn", self, "_on_player_respawn", [player_2])
	randomize()
	_ease_volume_on_start()
	get_node("UILayer/GUI").setup_controls()


func _on_restart_requested() -> void:
	emit_signal("restart_requested")

func _on_goto_next_level_requested() -> void:
	emit_signal("next_level_requested")
	
func _on_goto_main_menu_requested() -> void:
	emit_signal("main_menu_requested")
	
func _on_retry_level_requested() -> void:
	emit_signal("retry_level_requested")
	
func _on_player_dead(player: Player) -> void:
	#player.hide()
	pass
	
func _on_player_respawn(player: Player) -> void:
	print("_on_player_respawn")


func _ease_volume_on_start():
	var bus_name = "SFX"
	var bus_id = AudioServer.get_bus_index(bus_name)
	var bus_start_volume = AudioServer.get_bus_volume_db(bus_id)
	
	var timer = Timer.new()
	timer.connect("timeout",AudioServer,"set_bus_volume_db",[bus_id, bus_start_volume]) 
	timer.wait_time = 0.5
	timer.one_shot = true
	add_child(timer)

	AudioServer.set_bus_volume_db(bus_id, -80.0)
	timer.start()


func load_checkpoint():
	var checkpoint = GameState.checkpoint
	if checkpoint.size() > 1:
		player_1.global_position = checkpoint[0]
		player_2.global_position = checkpoint[1]
		var camera = $"%Camera2D"
		camera.global_position = checkpoint[0] + (checkpoint[1] - checkpoint[0])

