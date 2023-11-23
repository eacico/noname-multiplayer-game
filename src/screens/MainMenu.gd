extends Node

export (PackedScene) var level_manager_scene: PackedScene
#export (Texture) var mouse_cursor: Texture

export (bool) var start_on_test_scene: bool = false
export (int) var level_to_test = 0
export (int) var level_tutorial_01_id = 1
export (int) var level_01_id = 6

onready var start_tutorial_button = $CanvasLayer/Control/Container/StartTutorialButton

func _ready() -> void:
	if SceneSwitcher.get_param("start_on_test_scene") != null:
		start_on_test_scene = SceneSwitcher.get_param("start_on_test_scene")
	#Input.set_custom_mouse_cursor(mouse_cursor)
	if start_on_test_scene:
		SceneSwitcher.change_scene(level_manager_scene.resource_path, {"level": level_to_test})
	start_tutorial_button.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("test_level"):
		SceneSwitcher.change_scene(level_manager_scene.resource_path, {"level": 0})
		
func _on_StartButton_pressed() -> void:
	#get_tree().change_scene_to(level_manager_scene)
	SceneSwitcher.change_scene(level_manager_scene.resource_path, {"level": level_01_id})


func _on_ExitButton_pressed() -> void:
	get_tree().quit()


func _on_StartTutorialButton_pressed():
	SceneSwitcher.change_scene(level_manager_scene.resource_path, {"level": level_tutorial_01_id})
