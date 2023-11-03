extends RigidBody2D
class_name EnergyPlug

var joint: PinJoint2D
var socket: EnergySocket
var other_end_plug: EnergyPlug

onready var actionable = $Actionable

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_class(): return "EnergyPlug"

func has_energy(): return (socket and socket.has_energy()) or (other_end_plug.socket and other_end_plug.socket.has_energy())

func propagate_energy() -> void:
	if other_end_plug and other_end_plug.socket:
		other_end_plug.socket.evaluate_energy_state()

func _on_EnergyPlug_actioned(player: Player):
	var pick_position = player.get_node("PickPosition").global_position
	global_position = pick_position
	joint.global_position = pick_position
	
	joint.set_node_b(player.get_path())
	
	#print("energy plug picked by Player_%s" % [player.id])
	player.carrying.append(self)
	
	set_monitorable(false)
	
	socket.remove_plug()
	

var recognizable_actionables = [ "Player", "Switch", "EnergySocket" ]

func check_nearest_actionable(player) -> void:
	Utils.check_nearest_actionable(player, recognizable_actionables)

func set_monitorable(value: bool) -> void:
	set_collision_layer_bit(4, value)
	if actionable:
		actionable.set_deferred("monitorable", value)
	
