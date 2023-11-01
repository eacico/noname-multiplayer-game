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
	var pick_position = player.global_position
	pick_position.y = pick_position.y - player.get_node("CollisionShape2D").get_shape().get_extents().y
	global_position = pick_position
	joint.global_position = pick_position
	
	joint.set_node_b(player.get_path())
	
	#print("energy plug picked by Player_%s" % [player.id])
	player.carrying.append(self)
	
	set_monitorable(false)
	
	socket.remove_plug()
	

var recognizable_actionables = [ "Player", "Switch", "EnergySocket" ]

func is_recognizable_actionable(obj) -> bool:
	return recognizable_actionables.has(obj.get_class())

func check_nearest_actionable(player: Player) -> void:
	var areas: Array = []
	for area in player.actionable_finder.get_overlapping_areas():
		if is_recognizable_actionable(area):
			areas.append(area)
	for body in player.actionable_finder.get_overlapping_bodies():
		if is_recognizable_actionable(body):
			for body_child in body.get_children():
				if body_child is Actionable:
					areas.append(body_child)
					break
	var shortest_distance: float = INF
	var next_nearest_actionable: Actionable = null
	for area in areas:
		var distance: float = area.global_position.distance_to(global_position)
		if distance < shortest_distance and area != player.own_respawn_actionable and area.monitorable:
			shortest_distance = distance
			next_nearest_actionable = area
	
	if next_nearest_actionable != player.nearest_actionable or not is_instance_valid(next_nearest_actionable):
		player.emit_signal("nearest_actionable_changed", next_nearest_actionable)

func set_monitorable(value: bool) -> void:
	set_collision_layer_bit(4, value)
	if actionable:
		actionable.set_deferred("monitorable", value)
	
