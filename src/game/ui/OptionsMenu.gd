extends Control


func _ready() -> void:
	hide()


func _on_ReturnButton_pressed() -> void:
	hide()


func _input(event):
	if event.is_action_released("ui_cancel"):
		_on_ReturnButton_pressed()
