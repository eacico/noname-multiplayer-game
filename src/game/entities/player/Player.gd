extends KinematicBody2D
class_name Player


signal dead()
signal respawn()

const FLOOR_NORMAL: Vector2 = Vector2.UP  # Igual a Vector2(0, -1)
const SNAP_DIRECTION: Vector2 = Vector2.DOWN
const SNAP_LENGTH: float = 32.0
const SLOPE_THRESHOLD: float = deg2rad(46)

onready var floor_raycasts: Array = $FloorRaycasts.get_children()
onready var budy_color = $Body/ColorSprite
onready var ghost_body_color = $GhostBody/ColorSprite
onready var actionable_finder = $ActionableFinder
onready var action_alert = $Body/ActionAlert

## Estas variables de exportación podríamos abstraerlas a cada
## estado correspondiente de la state machine, pero como queremos
## poder modificar estos valores desde afuera de la escena del Player,
## los exponemos desde el script de Player.
export (float) var ACCELERATION: float = 30.0
export (float) var H_SPEED_LIMIT: float = 250.0
export (int) var jump_speed: int = 300
export (float) var JUMP_SPEED_LIMIT: float = 300.0
export (float) var FALL_SPEED_LIMIT: float = 850.0
export (float) var FRICTION_WEIGHT: float = 0.20
export (int) var gravity: int = 10
export (Color) var color: Color = Color.white
export (String) var id: String = "1"
export (float) var wall_slide_speed: float = 50.0



var velocity: Vector2 = Vector2.ZERO
var snap_vector: Vector2 = SNAP_DIRECTION * SNAP_LENGTH
var stop_on_slope: bool = true
var move_direction: int = 0
var is_wall_sliding: bool = false
var ghost_move_direction: Vector2 = Vector2.ZERO

## Flag de ayuda para saber identificar el estado de actividad
var dead: bool = false

onready var timer = $Timer

func _ready() -> void:
	budy_color.modulate = color
	ghost_body_color.modulate = color




## Se extrae el comportamiento del manejo del movimiento horizontal
## a una función para ser llamada apropiadamente desde la state machine
func _handle_move_input() -> void:
	move_direction = int(Input.is_action_pressed("p"+id+"_move_right")) - int(Input.is_action_pressed("p"+id+"_move_left"))
	if move_direction != 0:
		velocity.x = clamp(velocity.x + (move_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)


## Se extrae el comportamiento del manejo de la aplicación de fricción
## a una función para ser llamada apropiadamente desde la state machine
func _handle_deacceleration() -> void:
	velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0


## Se extrae el comportamiento de la aplicación de gravedad y movimiento
## a una función para ser llamada apropiadamente desde la state machine
func _apply_movement() -> void:
	if is_wall_sliding:
		velocity.y = clamp(velocity.y + gravity, JUMP_SPEED_LIMIT * -1, wall_slide_speed)
	else:
		velocity.y = clamp(velocity.y + gravity, JUMP_SPEED_LIMIT * -1, FALL_SPEED_LIMIT)
	velocity = move_and_slide_with_snap(
		velocity, 
		snap_vector, 
		FLOOR_NORMAL, 
		stop_on_slope, 
		4, 
		SLOPE_THRESHOLD)
	if is_on_floor() && snap_vector == Vector2.ZERO:
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH
	check_nearest_actionable()

func _apply_ghost_movement(delta: float) -> void:
	
	ghost_move_direction.x = int(Input.is_action_pressed("p"+id+"_move_right")) - int(Input.is_action_pressed("p"+id+"_move_left"))
	ghost_move_direction.y = int(Input.is_action_pressed("p"+id+"_move_down")) - int(Input.is_action_pressed("p"+id+"_move_up"))
	if ghost_move_direction.x != 0:
		velocity.x = clamp(velocity.x + (ghost_move_direction.x * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	if ghost_move_direction.y != 0:
		velocity.y = clamp(velocity.y + (ghost_move_direction.y * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
		
	velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	velocity.y = lerp(velocity.y, 0, FRICTION_WEIGHT) if abs(velocity.y) > 1 else 0
	
	position += velocity * delta
		

## Función que pisa la función is_on_floor() ya existente
## y le agrega el chequeo de raycasts para expandir la ventana
## de chequeo de piso
func is_on_floor() -> bool:
	var is_colliding: bool = .is_on_floor()
	for raycast in floor_raycasts:
		## Al tener deshabilitados los raycasts por default
		## ya que queremos que solamente se procesen en esta
		## función, debemos forzar una actualización
		raycast.force_raycast_update()
		is_colliding = is_colliding || raycast.is_colliding()
	return is_colliding


func notify_death() -> void:
	dead = true
	emit_signal("dead")

func notify_respawn() -> void:
	dead = false
	emit_signal("respawn")



func _handle_death() -> void:
	dead = true
	#emit_signal("hp_changed", 0, 1)


# El llamado a remove final
func _remove() -> void:
	set_physics_process(false)
	collision_layer = 0


## Wrapper sobre el llamado a animación para tener un solo punto de entrada controlable
## (en el caso de que necesitemos expandir la lógica o debuggear, por ejemplo)
func _play_animation(animation: String) -> void:
	pass


var nearest_actionable: Actionable = null
onready var own_respawn_actionable = $RespawnActionable
signal nearest_actionable_changed(actionable)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("p"+id+"_action"):
		get_viewport().set_input_as_handled()
		
		if is_instance_valid(nearest_actionable):
			nearest_actionable.emit_signal("actioned")

func check_nearest_actionable() -> void:
	var areas: Array = actionable_finder.get_overlapping_areas()
	var shortest_distance: float = INF
	var next_nearest_actionable: Actionable = null
	for area in areas:
		var distance: float = area.global_position.distance_to(global_position)
		if distance < shortest_distance and area != own_respawn_actionable and area.monitorable:
			shortest_distance = distance
			next_nearest_actionable = area
	
	if next_nearest_actionable != nearest_actionable or not is_instance_valid(next_nearest_actionable):
		#nearest_actionable = next_nearest_actionable
		emit_signal("nearest_actionable_changed", next_nearest_actionable)


func _on_Player_nearest_actionable_changed(actionable: Node):
	if actionable != null:
		print("nearest_actionable changed!! [%s]" % [actionable.name])
		action_alert.show()
	else:
		action_alert.hide()
	nearest_actionable = actionable
