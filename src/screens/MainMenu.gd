extends Node

export (PackedScene) var level_manager_scene: PackedScene
#export (Texture) var mouse_cursor: Texture


func _ready() -> void:
	pass #Input.set_custom_mouse_cursor(mouse_cursor)



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("test_level"):
		SceneSwitcher.change_scene(level_manager_scene.resource_path, {"level": 0})
		
func _on_StartButton_pressed() -> void:
	#get_tree().change_scene_to(level_manager_scene)
	SceneSwitcher.change_scene(level_manager_scene.resource_path)


func _on_ExitButton_pressed() -> void:
	get_tree().quit()
