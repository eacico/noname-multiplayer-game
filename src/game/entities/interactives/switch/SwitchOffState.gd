extends AbstractState

onready var off_sfx = $OffSFX

func enter() -> void:
	character._play_animation("off")
	off_sfx.play()


func handle_input(event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass

func handle_event(event: String, value = null) -> void:
	match event:
		"on":
			emit_signal("finished", "on")
