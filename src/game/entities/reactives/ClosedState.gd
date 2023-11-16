extends AbstractState

onready var closed_sfx = $ClosedSFX

func enter() -> void:
	character._play_animation("closed")
	character.slide_gate_closed()
	closed_sfx.play()

func handle_input(event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass

func handle_event(event: String, value = null) -> void:
	match event:
		"open":
			emit_signal("finished", "open")
