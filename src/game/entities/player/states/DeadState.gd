extends AbstractState

onready var body = $"../../Body"
onready var ghost_body = $"../../GhostBody"
onready var respawn_actionable = $"../../RespawnActionable"


## Al ser un estado de finalización (es decir, no se sale
## a ningun otro estado), vamos a procesar todo lo necesario
## en el enter
func enter() -> void:
	GameState.notify_player_death(character)
	character.emit_signal("dead")
	character._play_animation("die")
	body.hide()
	ghost_body.show()
	respawn_actionable.set_deferred("monitorable", true)
	


## Y en update solo manejamos la fricción y movimiento
## para que no sea un cubo de hielo al morir
func update(delta) -> void:
	#character._handle_deacceleration()
	#character._apply_movement()
	character._apply_ghost_movement(delta)


func _on_animation_finished(anim_name:String) -> void:
	character._remove()


func _on_RespawnActionable_actioned():
	if character.dead:
		print("Respawned!!")
		GameState.notify_player_respawn(character)
		character.notify_respawn()
		body.show()
		ghost_body.hide()
		respawn_actionable.set_deferred("monitorable", false)
		emit_signal("finished", "idle")
