extends Node2D
class_name Rope

var RopePiece = preload("res://src/game/entities/rope/RopePiece.tscn")
var piece_length := 6.0
var rope_parts := []
var rope_close_tolerance := 8.0
var rope_points : PoolVector2Array = []
var rope_colors : PoolColorArray = []
var rope_to_left := true
var active_rope_id : int = -INF setget set_active_rope_id

var color1 := Color.gold
var color2 := Color.black

#onready var rope_start_piece = $RopeStartPiece
#onready var rope_end_piece = $RopeEndPiece
#onready var rope_start_joint = $RopeStartPiece/C/J
#onready var rope_end_joint = $RopeEndPiece/C/J
var rope_start_piece
var rope_end_piece
var rope_start_joint
var rope_end_joint


func _process(_delta):
	get_rope_points()
	if rope_points.size() > 2:
		update()


func set_active_rope_id(value:int):
	if active_rope_id != value:
		active_rope_id = value
		if active_rope_id == -INF:
			for i in rope_parts:
				(i as RigidBody2D).mass = 1
		else:
			for i in len(rope_parts):
				if i == active_rope_id:
					(rope_parts[i] as RigidBody2D).mass = 10
				else:
					(rope_parts[i] as RigidBody2D).mass = 1


#func spawn_rope(start_pos:Vector2, end_pos:Vector2):
#	rope_start_piece.global_position = start_pos
#	rope_end_piece.global_position = end_pos
#	start_pos = rope_start_joint.global_position
#	end_pos = rope_end_joint.global_position
#	rope_to_left = start_pos.x < end_pos.x
#
#	var distance = start_pos.distance_to(end_pos)
#	var pieces_amount = round(distance / piece_length)
#	var spawn_angle = (end_pos-start_pos).angle() - PI/2
#
#	create_rope(pieces_amount, rope_start_piece, end_pos, spawn_angle)


func spawn_rope(_rope_start_piece, _rope_end_piece, slack_percentage: float):
	rope_start_piece = _rope_start_piece 
	rope_end_piece = _rope_end_piece
	rope_start_joint = rope_start_piece.get_node("C/J")
	rope_end_joint = rope_end_piece.get_node("C/J")
	var start_pos = rope_start_joint.global_position
	var end_pos = rope_end_joint.global_position
	rope_to_left = start_pos.x < end_pos.x
	
	#print("slack_percentage: %s - AB_distance: %s - ACB_distance: %s" % [slack_percentage, start_pos.distance_to(end_pos), start_pos.distance_to(end_pos) * (1+slack_percentage)])
	var mid_pos = Utils.calculateTrianglePoint(start_pos, end_pos, piece_length, start_pos.distance_to(end_pos) * (1+slack_percentage))
	
	rope_colors.append(color1)
	
	var distance1 = start_pos.distance_to(mid_pos)
	var pieces_amount1 = round(distance1 / piece_length)
	var spawn_angle1 = (mid_pos-start_pos).angle() - PI/2
	var last_piece1 = create_rope(pieces_amount1, rope_start_piece, mid_pos, spawn_angle1)

	var distance2 = mid_pos.distance_to(end_pos)
	var pieces_amount2 = round(distance2 / piece_length)
	var spawn_angle2 = (end_pos-mid_pos).angle() - PI/2
	var last_piece2 = create_rope(pieces_amount2, last_piece1, end_pos, spawn_angle2)
	if !last_piece2:
		last_piece2 = last_piece1
	rope_end_joint.node_a = rope_end_piece.get_path()
	rope_end_joint.node_b = last_piece2.get_path()
	
	rope_colors.append(color1 if rope_colors.size() % 2 == 0 else color2)

#	console_log("create_rope(%s[%s] - %s[%s])" % [rope_start_piece,start_pos,rope_end_piece,end_pos])
#	create_rope(pieces_amount, rope_start_piece, end_pos, spawn_angle)
#	console_log("  - rope created from %s to %s" % [rope_start_piece.global_position,rope_end_piece.global_position])

func create_rope(pieces_amount:int, parent:Object, end_pos:Vector2, spawn_angle:float) -> RopePiece:
#	rope_colors.append(color1)
	var last_color
	var fst_id = rope_parts.size()
	for i in pieces_amount:
		last_color = color2 if (fst_id + i) % 2 == 0 else color1
		rope_colors.append(last_color)
		
		parent = add_piece(parent, (fst_id + i), spawn_angle)
		parent.set_name("rope_piece_"+str(fst_id + i))
		rope_parts.append(parent)
		console_log("  add_piece(pos: %s)" % [parent.global_position])
		
		var joint_pos = parent.get_node("C/J").global_position
		if joint_pos.distance_to(end_pos) < rope_close_tolerance:
			break
	
#	last_color = color1 if last_color == color2 else color2
#	rope_colors.append(last_color)

#	rope_end_joint.node_a = rope_end_piece.get_path()
#	rope_end_joint.node_b = rope_parts[-1].get_path()
	if rope_parts.size() > 0:
		return rope_parts[-1]
	return null
	

func add_piece(parent:Object, id:int, spawn_angle:float) -> RopePiece:
	var joint : PinJoint2D = parent.get_node("C/J") as PinJoint2D
	var piece : RopePiece = RopePiece.instance() as RopePiece
	add_child(piece)
	piece.global_position = joint.global_position
	piece.rotation = spawn_angle
	piece.parent = self
	piece.id = id
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	return piece

func get_rope_points() -> void:
	var _parent_pos = get_parent().global_position
	rope_points = []
	rope_points.append( rope_start_joint.global_position - _parent_pos)
	for r in rope_parts:
		rope_points.append( r.global_position - _parent_pos)
	
	rope_points.append( rope_end_joint.global_position - _parent_pos)


func _draw():
	if rope_points.size() > 2:
		draw_polyline_colors(rope_points, rope_colors, 2.0, false)


func console_log(message, available = false):
	if available:
		print(message)
