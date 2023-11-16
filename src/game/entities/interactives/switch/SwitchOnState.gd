extends AbstractState

onready var on_sfx = $OnSFX

func enter() -> void:
	character._play_animation("on")
	on_sfx.play()


func handle_input(event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass

func handle_event(event: String, value = null) -> void:
	match event:
		"off":
			emit_signal("finished", "off")
