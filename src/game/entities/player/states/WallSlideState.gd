extends AbstractState

onready var detach_timer = $DetachTimer
onready var left_wall_ray_cast = $"../../WallRaycast/LeftRayCast2D"
onready var right_wall_ray_cast = $"../../WallRaycast/RightRayCast2D"

var wall_side: Vector2 = Vector2.ZERO

func enter() -> void:
	character.is_wall_sliding = true
	detect_wall_side()
	character._play_animation("wall_slide") 

func exit() -> void:
	character.is_wall_sliding = false
	
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("p"+character.id+"_jump") && player_is_detaching():
		emit_signal("finished", "jump")
	
func update(delta: float) -> void:
	character._apply_movement()
	if character.is_on_floor():
		emit_signal("finished", "idle")
	elif player_is_detaching() && detach_timer.is_stopped():
		detach_timer.start()

func handle_event(event: String, value = null) -> void:
	match event:
		"dead":
			#character._handle_hit(value)
			character._handle_death()
			if character.dead:
				emit_signal("finished", "dead")


func detect_wall_side() -> void:
	left_wall_ray_cast.force_raycast_update()
	right_wall_ray_cast.force_raycast_update()
	if left_wall_ray_cast.is_colliding():
		wall_side = Vector2.LEFT
	elif right_wall_ray_cast.is_colliding():
		wall_side = Vector2.RIGHT
	
func player_is_detaching() -> bool:
	return (wall_side == Vector2.LEFT && !(player_move_drection() < 0)) || (wall_side == Vector2.RIGHT && !(player_move_drection() > 0))

func player_move_drection() -> int:
	return int(Input.is_action_pressed("p"+character.id+"_move_right")) - int(Input.is_action_pressed("p"+character.id+"_move_left"))

func _on_DetachTimer_timeout():
	emit_signal("finished", "walk")
