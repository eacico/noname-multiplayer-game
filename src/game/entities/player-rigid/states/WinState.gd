extends AbstractState


func enter() -> void:
	var goal = character.get_node("../../Goal")
	character.set_deferred("mode", 1) #MODE_STATIC
	character.global_position = goal.global_position
	character._play_animation("enter")


func update(delta) -> void:
	pass


func _on_animation_finished(anim_name:String) -> void:
	GameState.notify_player_reached_goal(character.id)
	character.hide()
