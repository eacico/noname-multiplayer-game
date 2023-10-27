extends RigidBody2D
class_name EnergyPlug


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnergyPlug_actioned(player: Player):
	var pick_position = player.global_position
	pick_position.y = pick_position.y - player.get_node("CollisionShape2D").get_shape().get_extents().y
	global_position = pick_position
	
	var joint : PinJoint2D = PinJoint2D.new()
	add_child(joint)
	joint.set_node_a(player.get_path())
	joint.set_node_b(get_path())
	print("energy plug picked by Player_%s" % [player.id])
