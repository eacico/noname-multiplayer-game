extends AbstractState

onready var respawn_actionable = $"../../RespawnActionable"
onready var respawn_body = $"../../RespawnBody"

enum Mode {
	MODE_RIGID = 0
	MODE_STATIC = 1
	MODE_CHARACTER = 2
	MODE_KINEMATIC = 3
}


## Al ser un estado de finalización (es decir, no se sale
## a ningun otro estado), vamos a procesar todo lo necesario
## en el enter
func enter() -> void:
	GameState.notify_player_death(character)
	character.emit_signal("dead")
	character._play_animation("ghost")
	respawn_actionable.set_deferred("monitorable", true)
	character.set_deferred("mode", Mode.MODE_STATIC)


## Y en update solo manejamos la fricción y movimiento
## para que no sea un cubo de hielo al morir
func update(delta) -> void:
	#character._handle_deacceleration()
	#character._apply_movement()
	character._apply_ghost_movement(delta)


func _on_animation_finished(anim_name:String) -> void:
	print("Respawned!!")
	GameState.notify_player_respawn(character)
	character.notify_respawn()
	respawn_actionable.set_deferred("monitorable", false)
	character.set_deferred("mode", Mode.MODE_CHARACTER)
	emit_signal("finished", "idle")


func _on_RespawnActionable_actioned(player):
	if character.dead:
		character._play_animation("RESET")
		character.global_position = respawn_body.global_position
		
