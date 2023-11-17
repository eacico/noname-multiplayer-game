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
