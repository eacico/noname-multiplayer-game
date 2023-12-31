extends AbstractState

onready var land_sfx: AudioHandler = $"%LandSFX"

# Al entrar se activa primero la animación "walk"
func enter() -> void:
	character._play_animation("walk")


func handle_input(event:InputEvent) -> void:
	if !character.evaluate_inputs: return
	if event.is_action_pressed("p"+character.id+"_jump") && character.is_on_floor():
		emit_signal("finished", "jump")


# En esta función vamos a manejar las acciones apropiadas para este estado
func update(delta: float) -> void:
	# Vamos a manejar los inputs de movimiento
	character._handle_horizontal_move_input()
	# Aplicar ese movimiento, sin desacelerar
	character.check_nearest_actionable() #_apply_movement()
	
	# Y luego chequeamos si se quedó quieto el personaje
	if character.move_direction == 0:
		# Y cambiamos el estado a idle
		emit_signal("finished", "idle")
	else:
		# O aplicamos la animación que corresponde
		if character.is_on_floor():
			if character.get_current_animation() in ["fall", "jump"]:
				land_sfx.play()
			character._play_animation("walk")
		elif character.is_on_wall():
			emit_signal("finished", "wall_slide")
		else:
			if character.velocity.y > 0:
				character._play_animation("fall")
			else:
				character._play_animation("jump")


# En este callback manejamos, por el momento, solo los impactos
func handle_event(event: String, value = null) -> void:
	match event:
		"dead":
#			character._handle_hit(value)
			character._handle_death()
			if character.dead:
				emit_signal("finished", "dead")

