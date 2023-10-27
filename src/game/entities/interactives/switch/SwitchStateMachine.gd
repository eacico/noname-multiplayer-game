extends AbstractStateMachine

func _on_Switch_actioned(player):
	match current_state.state_id:
		"on":
			current_state.handle_event("off")
		"off":
			current_state.handle_event("on")
