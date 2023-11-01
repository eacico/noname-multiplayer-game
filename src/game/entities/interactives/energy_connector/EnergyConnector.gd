extends Node2D
class_name EnergyConnector

var Rope = preload("res://src/game/entities/rope/Rope.tscn")
#const EnergySocketResource = preload("res://src/game/entities/interactives/energy_connector/EnergySocket.tscn")
const EnergyPlugResource = preload("res://src/game/entities/interactives/energy_connector/EnergyPlug.tscn")
var energy_plugs: Array = []

var rope_instance: Rope

func _ready():
	if rope_instance == null:
		create_rope()


func create_rope() -> void:
	var desired_children = []
	var energy_sockets: Array = []
	for child in get_children():
		if child is EnergySocket:
			energy_sockets.append(child)
	
	if energy_sockets.size() >= 2:
		var socket1 = energy_sockets[0] as EnergySocket
		var socket2 = energy_sockets[1] as EnergySocket
		
		var ep1: EnergyPlug = EnergyPlugResource.instance()
		var ep2: EnergyPlug = EnergyPlugResource.instance()
		energy_plugs.append(ep1)
		energy_plugs.append(ep2)
		ep1.other_end_plug = ep2
		ep2.other_end_plug = ep1
		ep1.socket = socket1
		ep2.socket = socket2
		socket1.set_connected_plug(ep1)
		socket2.set_connected_plug(ep2)
		ep1.global_position = socket1.global_position
		ep2.global_position = socket2.global_position
		socket1.set_monitorable(false)
		socket2.set_monitorable(false)
		add_child(ep1)
		add_child(ep2)
		
		rope_instance = Rope.instance()
		add_child(rope_instance)
		rope_instance.spawn_rope(ep1, ep2)
		
		var joint1 = PinJoint2D.new()
		var joint2 = PinJoint2D.new()
		ep1.joint = joint1
		ep2.joint = joint2
		joint1.global_position = ep1.global_position
		joint2.global_position = ep2.global_position
		joint1.set_node_a(ep1.get_path())
		joint1.set_node_b(socket1.get_path())
		joint2.set_node_a(ep2.get_path())
		joint2.set_node_b(socket2.get_path())
		add_child(joint1)
		add_child(joint2)
		
		
