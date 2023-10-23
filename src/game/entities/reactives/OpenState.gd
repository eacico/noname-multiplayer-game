extends AbstractState

func enter() -> void:
	print("%s.enter()" % self.state_id)
	character._play_animation("open")
	character.slide_gate_open()


func handle_input(event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass

func handle_event(event: String, value = null) -> void:
	match event:
		"close":
			emit_signal("finished", "closed")
