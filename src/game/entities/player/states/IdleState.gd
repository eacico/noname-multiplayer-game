extends AbstractState

# Al entrar se activa primero la animación "idle"
func enter() -> void:
	character._play_animation("idle")


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("p"+character.id+"_jump") && character.is_on_floor():
		emit_signal("finished", "jump")


# En esta función vamos a manejar las acciones apropiadas para este estado
func update(delta: float) -> void:
	
	character._handle_move_input()
	# Para chequear si se realiza un movimiento
	if character.move_direction != 0:
		# Y cambiamos el estado a walk
		emit_signal("finished", "walk")
	else:
		# Si no se realiza movimiento, desaceleramos y manejamos movimiento
		character._handle_deacceleration()
		character._apply_movement()
		
		# Y aplicamos la animación apropiada, ya sea idle o saltar/caer
		if character.is_on_floor():
			character._play_animation("idle")
		else:
			if character.velocity.y > 0:
				character._play_animation("fall")
			else:
				character._play_animation("jump")


# En este callback manejamos, por el momento, solo los impactos
func handle_event(event: String, value = null) -> void:
	match event:
		"dead":
			character._handle_death()
			if character.dead:
				emit_signal("finished", "dead")

