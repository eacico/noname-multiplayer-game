extends AbstractState

func enter() -> void:
	character._play_animation("on")


func handle_input(event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass

func handle_event(event: String, value = null) -> void:
	match event:
		"off":
			emit_signal("finished", "off")
