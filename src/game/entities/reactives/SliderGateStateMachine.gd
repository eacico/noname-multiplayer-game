extends AbstractStateMachine


var switch_states: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_switched(state: bool, switch_id: int) -> void:
	print("_on_switched(state: %s, switch_id: %s)" % [state,switch_id])
	switch_states[switch_id] = state
	if not current_state == null:
		if switch_states.count(true) == switch_states.size():
			current_state.handle_event("open")
		else:
			current_state.handle_event("close")
