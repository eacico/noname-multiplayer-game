extends Control


func _ready() -> void:
	hide()


func _on_ReturnButton_pressed() -> void:
	hide()


func _input(event):
	if event.is_action_released("ui_cancel"):
		_on_ReturnButton_pressed()


func _on_OptionsMenu_visibility_changed():
	var dummy_player_1 = $Panel/Panel/Game/ViewportContainer/DummyPlayer1
	var dummy_player_2 = $Panel/Panel/Game/ViewportContainer/DummyPlayer2
	dummy_player_1.set_body_color(GameState.get_player_palette("1"))
	dummy_player_2.set_body_color(GameState.get_player_palette("2"))
