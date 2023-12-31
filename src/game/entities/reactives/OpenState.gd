extends AbstractState

onready var open_sfx = $OpenSFX

func enter() -> void:
	character._play_animation("open")
	character.slide_gate_open()
	open_sfx.play()

func handle_input(event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass

func handle_event(event: String, value = null) -> void:
	match event:
		"close":
			emit_signal("finished", "closed")
