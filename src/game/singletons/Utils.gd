extends Node


func is_recognizable_actionable(obj, recognizable_actionables) -> bool:
	return recognizable_actionables.has(obj.get_class())
	
func check_nearest_actionable(caller, recognizable_actionables: Array) -> void:

	var areas: Array = []
	for area in caller.actionable_finder.get_overlapping_areas():
		if is_recognizable_actionable(area, recognizable_actionables):
			areas.append(area)
	for body in caller.actionable_finder.get_overlapping_bodies():
		if is_recognizable_actionable(body, recognizable_actionables):
			for body_child in body.get_children():
				if body_child is Actionable:
					areas.append(body_child)
					break
	
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
