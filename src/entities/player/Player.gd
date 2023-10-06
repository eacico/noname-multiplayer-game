extends KinematicBody2D
class_name Player


signal dead()

const FLOOR_NORMAL: Vector2 = Vector2.UP  # Igual a Vector2(0, -1)
const SNAP_DIRECTION: Vector2 = Vector2.DOWN
const SNAP_LENGTH: float = 32.0
const SLOPE_THRESHOLD: float = deg2rad(46)

onready var floor_raycasts: Array = $FloorRaycasts.get_children()
onready var budy_color = $Body/ColorSprite

## Estas variables de exportación podríamos abstraerlas a cada
## estado correspondiente de la state machine, pero como queremos
## poder modificar estos valores desde afuera de la escena del Player,
## los exponemos desde el script de Player.
export (float) var ACCELERATION: float = 20.0
export (float) var H_SPEED_LIMIT: float = 250.0
export (int) var jump_speed: int = 300
export (float) var JUMP_SPEED_LIMIT: float = 300.0
export (float) var FALL_SPEED_LIMIT: float = 850.0
export (float) var FRICTION_WEIGHT: float = 0.15
export (int) var gravity: int = 10
export (Color) var color: Color = Color.white
export (String) var id: String = "1"
export (float) var wall_slide_speed: float = 50.0



var velocity: Vector2 = Vector2.ZERO
var snap_vector: Vector2 = SNAP_DIRECTION * SNAP_LENGTH
var stop_on_slope: bool = true
var move_direction: int = 0
var is_wall_sliding: bool = false

## Flag de ayuda para saber identificar el estado de actividad
var dead: bool = false

onready var timer = $Timer

func _ready() -> void:
	budy_color.modulate = color




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


func notify_death(amount: int = 1) -> void:
	emit_signal("dead")


## Y acá se maneja el hit final. Como aun no tenemos una "cantidad" de HP,
## sino una flag, el hit nos mata instantaneamente y tiramos una notificación.
## Esta signal tranquilamente podría llamarse "dead", pero como esa la utilizamos
## para otras cosas, y como sabemos que incorporaremos una barra de salud después
## es apropiado manejarlo de esta manera.
func _handle_death() -> void:
	dead = true
	emit_signal("hp_changed", 0, 1)


# El llamado a remove final
func _remove() -> void:
	set_physics_process(false)
	collision_layer = 0


## Wrapper sobre el llamado a animación para tener un solo punto de entrada controlable
## (en el caso de que necesitemos expandir la lógica o debuggear, por ejemplo)
func _play_animation(animation: String) -> void:
	pass

