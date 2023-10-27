extends Actionable
class_name Switch

signal switched(state)

export (NodePath) var Connection_TileMap setget set_Connection_TileMap, get_Connection_TileMap

onready var switch_on_sprite = $SwitchOnSprite
onready var switch_off_sprite = $SwitchOffSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	turn_switch_off()

func _on_finished(next_state_name):
	if next_state_name == "on":
		turn_switch_on()
	else:
		turn_switch_off()

func set_Connection_TileMap(node) -> void:
	Connection_TileMap = node

func get_Connection_TileMap() -> TileMap:
	return get_node(Connection_TileMap) as TileMap

func turn_switch_on() -> void:
	emit_signal("switched", true)
	get_Connection_TileMap().set_modulate(Color(0.255,0.392,0.255))
	switch_on_sprite.show()
	switch_off_sprite.hide()
	
func turn_switch_off() -> void:
	emit_signal("switched", false)
	get_Connection_TileMap().set_modulate(Color(0.45,0.216,0.216))
	switch_on_sprite.hide()
	switch_off_sprite.show()

func _play_animation(animation: String) -> void:
	pass
