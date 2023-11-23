tool
extends Button

onready var color_rect = $"%ColorRect"

export (String) var player_id: String
export (Color) var color: Color# setget _set_color
export (NodePath) var demo_player: NodePath


func _ready():
	if !Engine.editor_hint:
		if color:
			color_rect.modulate = color
		set_demo_player_color()

func _set_color(_color) -> void:
	color = _color
	if has_node("%ColorRect"):
		$"%ColorRect".modulate = color


func _on_ColorMapButton_pressed():
	GameState.change_player_palette(player_id, color)
	set_demo_player_color()

func set_demo_player_color():
	var player = get_node(demo_player)
	if player is DummyPlayer:
		player.set_body_color(GameState.get_player_palette(player_id))
