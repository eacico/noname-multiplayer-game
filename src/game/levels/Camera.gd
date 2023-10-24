extends Camera2D

onready var player1: Player = get_parent().get_node("Player1")
onready var player2: Player = get_parent().get_node("Player2")

export (float) var min_zoom: float = 1.0
export (float) var max_zoom: float = 2.0
export (Vector2) var zoom_offset: Vector2 = Vector2(100,100)

	

func _physics_process(delta: float) -> void:
	var average_position = (player1.global_position + player2.global_position) / 2
	var distance = Vector2(abs(player1.global_position.x - player2.global_position.x) , abs(player1.global_position.y - player2.global_position.y))
	distance += zoom_offset
	global_position = average_position
	var viewport_size : Vector2 = get_viewport_rect().size
	var zoom_factor = clamp(max(distance.x / viewport_size.x, distance.y / viewport_size.y), min_zoom, max_zoom)
	zoom = Vector2(zoom_factor , zoom_factor)
	
	
