extends Node2D
class_name EnergyConnector

var Rope = preload("res://src/game/entities/rope/Rope.tscn")
var energy_plugs: Array = []

var rope_instance: Rope

func _ready():
	if rope_instance == null:
		create_rope()

func create_rope() -> void:
	var desired_children = []
	for child in get_children():
		if child is EnergyPlug:
			energy_plugs.append(child)
	
	if energy_plugs.size() >= 2:
		var ep1 = energy_plugs[0] as EnergyPlug
		var ep2 = energy_plugs[1] as EnergyPlug
	
		rope_instance = Rope.instance()
		add_child(rope_instance)
		rope_instance.spawn_rope(ep1, ep2)
