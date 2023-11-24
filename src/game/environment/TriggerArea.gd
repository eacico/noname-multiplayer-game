extends Area2D

## Implementación de trigger genérico de eventos. Puede llamar a
## N nodos, con M métodos con L parámetros o con M variables.

## Una implementación más compleja con Timers podría permitir cosas como,
## por ejemplo, un sistema de cinemáticas, moviendo los parámetros
## de la Camera de forma custom en tiempos determinados e inmovilizando
## al Player.

export (Array, NodePath) var nodes_affected: Array
export (Array, PoolStringArray) var methods_list: Array
export (Array, Array, Array) var parameters: Array


func _ready() -> void:
	pass #connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body: Node) -> void:
	for i in nodes_affected.size():
		var node: Node = get_node(nodes_affected[i])
		var methods: PoolStringArray = methods_list[i]
		var params: Array = parameters[i]
		console_log("%s (methods: %s, params: %s):" % [node.name, methods.size(), params.size()])
		for m in methods.size():
			var method: String = methods[m]
			if node.has_method(method):
				console_log("  callv %s(%s)" % [method, params[m]])
				node.callv(method, [body] + params[m])
			elif method in node && !params[m].empty():
				console_log("  set %s = %s" % [method, params[m][0]])
				node.set(method, params[m][0])
			else:
				console_log("  method '%s' NOT FOUND!!" % [method])

func _on_TriggerArea_area_entered(area):
	_on_body_entered(area)
	
func console_log(message, available = false):
	if available:
		print(message)


