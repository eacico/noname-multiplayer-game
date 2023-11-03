extends Camera2D

onready var player1 = get_parent().get_node("Player1")
onready var player2 = get_parent().get_node("Player2")

export (float) var min_zoom: float = 1.0
export (float) var max_zoom: float = 2.0
export (Vector2) var zoom_offset: Vector2 = Vector2(100,100)
export (float) var map_left_margin: float = 0
export (float) var map_right_margin: float = 0
export (float) var zoom_speed: float = 3

	

func _physics_process(delta: float) -> void:
	var p1_at_left: bool = player1.global_position.x < player2.global_position.x
	var left_end_corner: Vector2 = player1.global_position if p1_at_left else player2.global_position
	var right_end_corner: Vector2 = player2.global_position if p1_at_left else player1.global_position
	
	if map_left_margin != 0 and map_right_margin != 0: 
		left_end_corner = Vector2(min(left_end_corner.x, map_left_margin), left_end_corner.y)
		right_end_corner = Vector2(max(right_end_corner.x, map_right_margin), right_end_corner.y)
		#print(left_end_corner)
	
	var average_position = (left_end_corner + right_end_corner) / 2
	var distance = Vector2(abs(left_end_corner.x - right_end_corner.x) , abs(left_end_corner.y - right_end_corner.y))
	distance += zoom_offset
	
	#global_position = average_position
	global_position = lerp(global_position, average_position, zoom_speed * delta)
	
	var viewport_size : Vector2 = get_viewport_rect().size
	var zoom_factor = clamp(max(distance.x / viewport_size.x, distance.y / viewport_size.y), min_zoom, max_zoom)
	
	#zoom = Vector2(zoom_factor , zoom_factor)
	var target_zoom = Vector2(zoom_factor, zoom_factor)
	zoom = lerp(zoom, target_zoom, zoom_speed * delta)
	
	
