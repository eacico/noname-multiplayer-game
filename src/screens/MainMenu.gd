extends Node

export (PackedScene) var level_manager_scene: PackedScene
#export (Texture) var mouse_cursor: Texture


func _ready() -> void:
	pass #Input.set_custom_mouse_cursor(mouse_cursor)



func _on_StartButton_pressed() -> void:
	get_tree().change_scene_to(level_manager_scene)


func _on_ExitButton_pressed() -> void:
	get_tree().quit()
