extends Node2D
class_name EnergyConnector

export (float, 0, 1) var slack_percentage:float = 0.1
export (Color) var color1 := Color.gold
export (Color) var color2 := Color.black

var Rope = preload("res://src/game/entities/rope/Rope.tscn")
#const EnergySocketResource = preload("res://src/game/entities/interactives/energy_connector/EnergySocket.tscn")
const EnergyPlugResource = preload("res://src/game/entities/interactives/energy_connector/EnergyPlug.tscn")
var energy_plugs: Array = []

var rope_instance: Rope

func _ready():
	if rope_instance == null:
		create_rope()


func create_rope() -> void:
	var energy_sockets: Array = []
	for child in get_children():
		if child is EnergySocket:
			energy_sockets.append(child)
	
	if energy_sockets.size() >= 2:
		var socket1 = energy_sockets[0] as EnergySocket
		var socket2 = energy_sockets[1] as EnergySocket
		
		var ep1: EnergyPlug = EnergyPlugResource.instance()
		var ep2: EnergyPlug = EnergyPlugResource.instance()
		add_child(ep1)
		add_child(ep2)
		ep1.global_position = socket1.global_position
		ep2.global_position = socket2.global_position
		energy_plugs.append(ep1)
		energy_plugs.append(ep2)
		ep1.other_end_plug = ep2
		ep2.other_end_plug = ep1
		ep1.socket = socket1
		ep2.socket = socket2
		ep1.set_mass(5)
		ep2.set_mass(5)
		ep1.set_gravity_scale(9)
		ep2.set_gravity_scale(9)
		socket1.set_connected_plug(ep1)
		socket2.set_connected_plug(ep2)
		socket1.set_monitorable(false)
		socket2.set_monitorable(false)
		
		rope_instance = Rope.instance()
		rope_instance.color1 = color1
		rope_instance.color2 = color2
		add_child(rope_instance)
		rope_instance.spawn_rope(ep1, ep2, slack_percentage)
		
		var joint1 = PinJoint2D.new()
		var joint2 = PinJoint2D.new()
		add_child(joint1)
		add_child(joint2)
		joint1.global_position = ep1.global_position
		joint2.global_position = ep2.global_position
		ep1.joint = joint1
		ep2.joint = joint2
		joint1.set_node_a(ep1.get_path())
		joint1.set_node_b(socket1.get_path())
		joint2.set_node_a(ep2.get_path())
		joint2.set_node_b(socket2.get_path())
		
		create_leash(ep1, ep2)
		
func create_leash(ep1: EnergyPlug, ep2: EnergyPlug) -> void:
	var pos1 = ep1.global_position
	var pos2 = ep2.global_position
	
	var distance = (pos1.distance_to(pos2) * 2) * (1 + slack_percentage)
	var spawn_angle = (pos2-pos1).angle() - PI/2
	
	var groove_joint = GrooveJoint2D.new()
	add_child(groove_joint)
	groove_joint.global_position = pos1 - ((pos2-pos1) * (1 + slack_percentage))
	groove_joint.set_length(distance)
	groove_joint.set_initial_offset((distance / 2) + pos1.distance_to(pos2))
	groove_joint.set_rotation(spawn_angle)
	groove_joint.set_node_a(ep1.get_path())
	groove_joint.set_node_b(ep2.get_path())
	
	
	














