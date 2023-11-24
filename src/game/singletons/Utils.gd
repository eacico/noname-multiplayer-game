extends Node


func is_recognizable_actionable(obj, recognizable_actionables) -> bool:
	return recognizable_actionables.has(obj.get_class())
	
func check_nearest_actionable(caller, recognizable_actionables: Array) -> void:

	var areas: Array = []
	for area in caller.actionable_finder.get_overlapping_areas():
		if is_recognizable_actionable(area.get_parent(), recognizable_actionables):
			areas.append(area)
#	for body in caller.actionable_finder.get_overlapping_bodies():
#		if is_recognizable_actionable(body, recognizable_actionables):
#			for body_child in body.get_children():
#				if body_child is Actionable:
#					areas.append(body_child)
#					break
	
	var shortest_distance: float = INF
	var next_nearest_actionable: Actionable = null
	for area in areas:
		var distance: float = area.global_position.distance_to(caller.global_position)
		if distance < shortest_distance and area != caller.own_respawn_actionable and area.monitorable:
			shortest_distance = distance
			next_nearest_actionable = area
	
	if next_nearest_actionable != caller.nearest_actionable or not is_instance_valid(next_nearest_actionable):
		#nearest_actionable = next_nearest_actionable
		caller.emit_signal("nearest_actionable_changed", next_nearest_actionable)


func calculateTrianglePoint(A: Vector2, B: Vector2, step: float, ACB_distance: float) -> Vector2:
	var AB_distance = A.distance_to(B)  # Distance between A and B
	var rounded_distance = round(ACB_distance / step) * step
	var AC_distance = round((rounded_distance / step) / 2) * step
	var BC_distance = rounded_distance - AC_distance
	
	#print("AB_distance: %s - ACB_distance: %s - AC_distance: %s - BC_distance: %s"%[AB_distance,ACB_distance, AC_distance, BC_distance])
	
	var C = Vector2.ZERO
	C.x = (pow(AC_distance,2) - pow(BC_distance,2) + pow(AB_distance,2)) / (2 * AB_distance)
	C.y = sqrt(pow(AC_distance,2) - pow(pow(AC_distance,2) - pow(BC_distance,2) + pow(AB_distance,2),2)/(4*pow(AB_distance,2)));
	
	C.y = round(A.y + C.y)
	C.x = round(A.x + C.x)
	
	#print("[A:%s,B:%s,C:%s] - d(AB): %s - d(ACB): (%s - %s) - d(AC): (%s - %s) - d(BC): (%s - %s)" % [A, B, C, AB_distance, ACB_distance,(A.distance_to(C) + C.distance_to(B)), AC_distance,A.distance_to(C), BC_distance,C.distance_to(B)])
	#print("Puntos del triangulo: %s - %s - %s" % [A, B, C])
	if is_nan(C.x) or is_nan(C.y):
		return B
	return C;
	





