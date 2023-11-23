extends Control

onready var panel = $Panel/Panel
onready var panel_tabs_size = panel.get_children().size()

func _ready() -> void:
	hide()
	load_connected_joypads()


func _on_ReturnButton_pressed() -> void:
	hide()


func _input(event):
	if event.is_action_released("ui_cancel"):
		_on_ReturnButton_pressed()
	elif event.is_action_released("ui_tab_next"):
		panel.set_current_tab((panel.current_tab + 1) % panel_tabs_size)
	elif event.is_action_released("ui_tab_prev"):
		panel.set_current_tab((panel_tabs_size + panel.current_tab - 1) % panel_tabs_size)

func show():
	.show()
	load_connected_joypads()

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

var player_inputs = [ 
	"move_left",
	"move_right",
	"move_up",
	"move_down",
	"action",
	"jump"
]

func load_connected_joypads():
	var p1_Joypad_list = $Panel/Panel/Game/HBoxContainerJoy1/ItemList
	var p2_Joypad_list = $Panel/Panel/Game/HBoxContainerJoy2/ItemList
	
	p1_Joypad_list.clear()
	p2_Joypad_list.clear()
	p1_Joypad_list.add_item("n/a", -1)
	p2_Joypad_list.add_item("n/a", -1)
	
	for jid in Input.get_connected_joypads():
		p1_Joypad_list.add_item(String(jid), jid)
		p2_Joypad_list.add_item(String(jid), jid)
	
	select_device(p1_Joypad_list, get_player_device_id(1))
	select_device(p2_Joypad_list, get_player_device_id(2))

func select_device(ob: OptionButton, device_id: int):
	for i in ob.get_item_count():
		if ob.get_item_text(i) == String(device_id):
			ob.select(i)
			break

func get_player_device_id(player_id: int) -> int:
	var action = "p%s_%s" % [player_id,player_inputs[0]]
	
	if InputMap.has_action(action):
		for event in InputMap.get_action_list(action):
			if event is InputEventJoypadButton or event is InputEventJoypadMotion:
				return event.device
	return -1

func set_player_device_id(player_id: String, device_id: int):
	for input in player_inputs:
		var action = "p%s_%s" % [player_id,input]
		if InputMap.has_action(action):
			for event in InputMap.get_action_list(action):
				if event is InputEventJoypadButton or event is InputEventJoypadMotion:
					event.device = device_id

func _on_connected_joypad_toggled(button_pressed, player_id: String):
	if !button_pressed:
		var p_Joypad_list: OptionButton
		match player_id:
			"1":
				p_Joypad_list = $Panel/Panel/Game/HBoxContainerJoy1/ItemList
			"2":
				p_Joypad_list = $Panel/Panel/Game/HBoxContainerJoy2/ItemList
		
		
		var device_id: String = p_Joypad_list.get_item_text(p_Joypad_list.selected)
		
		set_player_device_id(player_id, int(7 if device_id == "n/a" else -1))
		print("Player %s Joypad changed to %s" % [player_id, device_id])


