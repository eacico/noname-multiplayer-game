extends AbstractState


# Al entrar se activa primero la animación "walk"
func enter() -> void:
	character._play_animation("walk")


func handle_input(event:InputEvent) -> void:
	if event.is_action_pressed("p"+character.id+"_jump") && character.is_on_floor():
		emit_signal("finished", "jump")


# En esta función vamos a manejar las acciones apropiadas para este estado
func update(delta: float) -> void:
	# Vamos a manejar los inputs de movimiento
	character._handle_move_input()
	# Aplicar ese movimiento, sin desacelerar
	character.check_nearest_actionable() #_apply_movement()
	
	# Y luego chequeamos si se quedó quieto el personaje
	if character.move_direction == 0:
		# Y cambiamos el estado a idle
		emit_signal("finished", "idle")
	else:
		# O aplicamos la animación que corresponde
		if character.is_on_floor():
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

