extends Control

## Escena que presenta la información que figura en pantalla durante
## el juego. Maneja tanto lo que es barras de salud como información
## general.

onready var fade_elements: Control = $"%FadeElements"

onready var fading_elements: Array = [
	fade_elements
]

export (float) var fade_duration: float = 5.0
export (float) var fade_delay: float = 2.0

var stats_tween: SceneTreeTween


# Recupera la información de cuál es el Player actual desde GameState.
func _ready() -> void:
	GameState.connect("current_players_changed", self, "_on_current_players_changed")
	get_parent().get_node("PauseMenu").connect("visibility_changed", self, "_animate_fade")


## Cuando se asigna un Player nuevo, se conecta a las señales que
## interesan, y se refresca la data.
func _on_current_players_changed() -> void:
	if stats_tween:
		stats_tween.kill()
	for element in fading_elements:
		element.modulate = Color.transparent
	_animate_fade()


# Función de ayuda para animar el fade-out de elementos de la escena.
func _animate_fade() -> void:
	if !is_inside_tree():
		return
	
	if stats_tween:
		stats_tween.kill()
	stats_tween = create_tween()
	
	for element in fading_elements:
		element.modulate = Color.white
		stats_tween.set_parallel().tween_property(element, "modulate", Color.transparent, fade_duration).set_trans(Tween.TRANS_SINE).set_delay(fade_delay)


var controls = [
	"move_left",
	"move_right",
	"move_up",
	"move_down",
	"action",
	"jump"
]
func setup_controls():
	for pid in range(2):
		var color: Color = GameState.player_palette[pid]
		color.a = 0.6
		var player_control_container = get_node("ControlsContainer/FadeElements/Player%sContainer" % [pid + 1])
		player_control_container.set_modulate(color)
		for control_name in controls:
			var control_label = player_control_container.get_node("Sprite/Label_%s" % [control_name])
			control_label.text = get_control_key_shrinked("p%s_%s" % [pid + 1, control_name])

func get_control_key_shrinked(action: String):
	var text = get_control_key(action)
	match text.to_lower():
		"left":
			return "<"
		"right":
			return ">"
		"down":
			return "v"
		"up":
			return "^"
		"control":
			return "Ctrl"
		_:
			return text

func get_control_key(action: String):
	for event in InputMap.get_action_list(action):
		if event is InputEventKey:
			return event.as_text()
	return "-"


