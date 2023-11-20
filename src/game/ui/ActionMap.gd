tool
extends Control

# Basado en https://github.com/godotengine/godot-demo-projects/blob/3.x/gui/input_mapping/ActionRemapButton.gd

onready var action_name_label: Label = $"%ActionNameLabel"
onready var action_key_button: Button = $"%ActionKeyButton"

export (String) var action: String
export (String) var action_name: String setget _set_action_name

var joypad_button_desc = [
	"Cross",
	"Circle",
	"Square",
	"Triangle",
	"L1",
	"R1",
	"L2",
	"R2",
	"L3",
	"R3",
	"Select",
	"Start",
	"D-Pad Up",
	"D-Pad Down",
	"D-Pad Left",
	"D-Pad Right"
]

func _ready() -> void:
	set_process_input(false)
	if !Engine.editor_hint && InputMap.has_action(action) && InputMap.get_action_list(action).size() > 0:
		var event: InputEvent = InputMap.get_action_list(action)[0]
		_set_event(event)


func _on_ActionKeyButton_pressed() -> void:
	set_process_input(true)
	action_key_button.text = "..."
	action_key_button.release_focus()


func _input(event: InputEvent) -> void:
	if !event is InputEventMouseMotion:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		_set_event(event)
		set_process_input(false)
		GameState.notify_input_map_changed()
		yield(get_tree().create_timer(0.1), "timeout")
		action_key_button.grab_focus()


func _set_event(event: InputEvent) -> void:
	action_key_button.text = event.as_text()
	
	if event is InputEventMouseButton:
		action_key_button.text = event.as_text().get_slice(":", 1).get_slice(",", 0).get_slice("=", 1)
	elif event is InputEventJoypadButton:
		var event_button_id = event.get_button_index()
		if event_button_id in range(joypad_button_desc.size()):
			action_key_button.text = "Joy%s - %s" % [event.device + 1,joypad_button_desc[event_button_id]]
		


func _set_action_name(nm: String) -> void:
	action_name = nm
	if has_node("%ActionNameLabel"):
		$"%ActionNameLabel".text = nm
