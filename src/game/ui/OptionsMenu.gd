extends Control

onready var panel = $Panel/Panel
onready var panel_tabs_size = panel.get_children().size()

func _ready() -> void:
	hide()


func _on_ReturnButton_pressed() -> void:
	hide()


func _input(event):
	if event.is_action_released("ui_cancel"):
		_on_ReturnButton_pressed()
	elif event.is_action_released("ui_tab_next"):
		panel.set_current_tab((panel.current_tab + 1) % panel_tabs_size)
	elif event.is_action_released("ui_tab_prev"):
		panel.set_current_tab((panel_tabs_size + panel.current_tab - 1) % panel_tabs_size)


func _on_OptionsMenu_visibility_changed():
	var dummy_player_1 = $Panel/Panel/Game/ViewportContainer/DummyPlayer1
	var dummy_player_2 = $Panel/Panel/Game/ViewportContainer/DummyPlayer2
	dummy_player_1.set_body_color(GameState.get_player_palette("1"))
	dummy_player_2.set_body_color(GameState.get_player_palette("2"))
	
	_on_Panel_tab_changed(panel.current_tab)


func _on_Panel_tab_changed(tab):
	match tab:
		0:
			var color_map_button = $Panel/Panel/Game/HBoxContainer1/ColorMapButton
			color_map_button.grab_focus()
		1:
			var action_map_fst_button = $Panel/Panel/Controls/HBoxContainer/VBoxContainer1/ActionMap_P1_K_Left
			action_map_fst_button.grab_focus()
		2:
			var audio_bus_options = $Panel/Panel/Audio/VBoxContainer/AudioBusOptions
			audio_bus_options.grab_focus()
