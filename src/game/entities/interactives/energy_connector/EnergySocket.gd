extends RigidBody2D
class_name EnergySocket

signal switched(state)

onready var actionable = $Actionable
onready var plugged_sfx = $PluggedSFX
onready var unplugged_sfx = $UnpluggedSFX

export (bool) var is_energy_source: bool = false
export (NodePath) var Connection_TileMap setget set_Connection_TileMap, get_Connection_TileMap

var connected_plug: Object = null setget set_connected_plug  #EnergyPlug
var color_on = Color(0.255,0.392,0.255)
var color_off = Color(0.45,0.216,0.216)

func _ready():
	evaluate_energy_state()

func get_class(): return "EnergySocket"

func has_energy(): return is_energy_source



func set_monitorable(value: bool) -> void:
	set_collision_layer_bit(4, value)
	if actionable:
		actionable.set_deferred("monitorable", value)
	
func _on_EnergySocket_actioned(player):
	#print("Player_%s: connected EnergyPlug." % [player.id])
	if !player.carrying:
		return
		
	set_connected_plug(player.carrying[0])
	
	connected_plug.global_position = global_position
	connected_plug.joint.global_position = global_position
	
	connected_plug.joint.set_node_b(get_path())
	
	player.carrying.erase(connected_plug)
	
	connected_plug.set_monitorable(true)
	
	evaluate_energy_state()


func evaluate_energy_state() -> void:
	if has_energy() or (connected_plug and connected_plug.has_energy()):
		turn_socket_on()
	else:
		turn_socket_off()


func set_connected_plug(plug) -> void:
	if plug:
		plug.socket = self
		plug.propagate_energy()
		plugged_sfx.play()
	elif connected_plug:
		connected_plug.socket = null
		connected_plug.propagate_energy()
		unplugged_sfx.play()
		
	connected_plug = plug
	
	set_monitorable(plug == null)
	
	evaluate_energy_state()

func remove_plug() -> void:
	if connected_plug.other_end_plug.socket:
		connected_plug.other_end_plug.socket.evaluate_energy_state()
	set_connected_plug(null)


func set_Connection_TileMap(node) -> void:
	Connection_TileMap = node

func get_Connection_TileMap() -> TileMap:
	return get_node(Connection_TileMap) as TileMap




func turn_socket_on() -> void:
	#print("socket -> switched(on)")
	emit_signal("switched", true)
	if Connection_TileMap:
		get_Connection_TileMap().set_modulate(color_on)
	
func turn_socket_off() -> void:
	emit_signal("switched", false)
	if Connection_TileMap:
		get_Connection_TileMap().set_modulate(color_off)
