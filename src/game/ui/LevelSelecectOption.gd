tool
extends Control

onready var button = $"%Button"
onready var label = $"%Label"

export (PackedScene) var level_manager_scene: PackedScene
export (Texture) var level_image: Texture setget _set_level_image
export (int) var level_id: int
export (String) var level_name: String setget _set_level_name


func _set_level_name(nm: String) -> void:
	level_name = nm
	if has_node("%Label"):
		$"%Label".text = nm

func _set_level_image(image: Texture) -> void:
	level_image = image
	if has_node("%ButtonTexture"):
		var bt = $"%ButtonTexture"
		bt.set_texture(image)



func _on_Button_pressed():
	SceneSwitcher.change_scene(level_manager_scene.resource_path, {"level": level_id})
