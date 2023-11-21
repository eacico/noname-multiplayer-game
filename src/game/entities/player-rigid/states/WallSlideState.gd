extends AbstractState

onready var detach_timer = $DetachTimer
onready var left_wall_ray_cast = $"../../WallRaycast/LeftRayCast2D"
onready var right_wall_ray_cast = $"../../WallRaycast/RightRayCast2D"
onready var jump = $"../Jump"

var wall_side: Vector2 = Vector2.ZERO

func enter() -> void:
	character.is_wall_sliding = true
	detect_wall_side()
	character._play_animation("slide") 

func exit() -> void:
	character.is_wall_sliding = false
	
func handle_input(event: InputEvent) -> void:
	if !character.evaluate_inputs: return
	if event.is_action_pressed("p"+character.id+"_jump"): # && player_is_detaching():
		detach_timer.stop()
		jump.jumps = 1
		character.added_velocity.x = character.H_SPEED_LIMIT * -wall_side.x# * 0.75 * jump_direction()
		emit_signal("finished", "jump")
	
func update(delta: float) -> void:
	character.check_nearest_actionable() #_apply_movement()
	if character.is_on_floor() or !player_is_near_wall():
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

func player_is_near_wall() -> bool:
	left_wall_ray_cast.force_raycast_update()
	right_wall_ray_cast.force_raycast_update()
	return left_wall_ray_cast.is_colliding() or right_wall_ray_cast.is_colliding()

func player_move_drection() -> int:
	return int(Input.is_action_pressed("p"+character.id+"_move_right")) - int(Input.is_action_pressed("p"+character.id+"_move_left"))

func jump_direction(): return int(wall_side == Vector2.LEFT) - int(wall_side == Vector2.RIGHT)

func _on_DetachTimer_timeout():
	emit_signal("finished", "idle")
