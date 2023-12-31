extends Control

## Menú de pausa genérico, abierto utilizando la acción "pause_menu"
## (por default la tecla Esc).

signal return_selected()
signal restart_selected()
signal retry_selected()

onready var options_menu: Control = $OptionsMenu
onready var resume_button = $Panel/VBoxContainer/ResumeButton


func _ready() -> void:
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("pause_menu") && !options_menu.visible:
		visible = !visible
		get_tree().paused = visible
		resume_button.grab_focus()


func _on_ReturnButton_pressed() -> void:
	hide()
	emit_signal("return_selected")


func _on_RestartButton_pressed() -> void:
	hide()
	emit_signal("restart_selected")

func _on_RetryButton_pressed() -> void:
	hide()
	emit_signal("retry_selected")


func _on_ResumeButton_pressed() -> void:
	hide()


func show() -> void:
	.show()
	get_tree().paused = true


func hide() -> void:
	.hide()
	get_tree().paused = false
