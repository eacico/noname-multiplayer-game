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


func _on_Panel_tab_changed(tab):
	match tab:
		0:
			pass #color_map_button.grab_focus()
		1:
			pass #action_map_fst_button.grab_focus()


