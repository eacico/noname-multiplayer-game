extends AbstractState

func enter() -> void:
	print("%s.enter()" % self.state_id)
	character._play_animation("closed")
	character.slide_gate_closed()


func handle_input(event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass

func handle_event(event: String, value = null) -> void:
	match event:
		"open":
			emit_signal("finished", "open")
