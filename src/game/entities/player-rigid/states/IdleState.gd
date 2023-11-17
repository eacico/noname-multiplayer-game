extends AbstractState

onready var land_sfx: AudioHandler = $"%LandSFX"

# Al entrar se activa primero la animación "idle"
func enter() -> void:
	#print("%s.enter(%s - idle)" % [get_parent().get_parent().name, get_parent().character.name])
	character._play_animation("idle")


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("p"+character.id+"_jump") && character.is_on_floor():
		emit_signal("finished", "jump")


# En esta función vamos a manejar las acciones apropiadas para este estado
func update(delta: float) -> void:
	
	character._handle_horizontal_move_input()
	# Para chequear si se realiza un movimiento
	if character.move_direction != 0:
		# Y cambiamos el estado a walk
		emit_signal("finished", "walk")
	else:
		# Si no se realiza movimiento, desaceleramos y manejamos movimiento
		character._handle_deacceleration()
		character.check_nearest_actionable() #_apply_movement()
		
		# Y aplicamos la animación apropiada, ya sea idle o saltar/caer
		if character.is_on_floor():
			if character.get_current_animation() in ["fall", "jump"]:
				land_sfx.play()
			#character._play_animation("idle")
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

