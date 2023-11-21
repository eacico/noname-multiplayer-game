extends RigidBody2D
class_name Player


signal dead()
signal respawn()

const FLOOR_NORMAL: Vector2 = Vector2.UP  # Igual a Vector2(0, -1)
const SNAP_DIRECTION: Vector2 = Vector2.DOWN
const SNAP_LENGTH: float = 32.0
const SLOPE_THRESHOLD: float = deg2rad(46)

onready var floor_raycasts: Array = $FloorRaycasts.get_children()
onready var wall_raycasts: Array  = $WallRaycast.get_children()
onready var actionable_finder = $ActionableFinder
onready var action_alert = $BodyPivot/ActionAlert
onready var body_animations = $BodyAnimations
onready var body_color = $"%ColorSprite"
onready var body_pivot = $BodyPivot
onready var alert_sfx = $"%AlertSFX"
onready var state_machine = $StateMachine

## Estas variables de exportación podríamos abstraerlas a cada
## estado correspondiente de la state machine, pero como queremos
## poder modificar estos valores desde afuera de la escena del Player,
## los exponemos desde el script de Player.
export (float) var ACCELERATION: float = 18.0
export (float) var AIR_ACCELERATION: float = 13.0
export (float) var H_SPEED_LIMIT: float = 230.0
export (float) var GHOST_SPEED_LIMIT: float = 150.0
export (int) var jump_speed: int = 300
export (float) var JUMP_SPEED_LIMIT: float = 350.0
export (float) var FALL_SPEED_LIMIT: float = 850.0
export (float) var FRICTION_WEIGHT: float = 0.25
export (float) var AIR_FRICTION_WEIGHT: float = 0.08
export (int) var gravity: int = 10
export (Color) var color: Color = Color.white
export (String) var id: String = "1"
export (float) var wall_slide_speed: float = 50.0
export (bool) var evaluate_inputs: bool = true



var velocity: Vector2 = Vector2.ZERO
var added_velocity: Vector2 = Vector2.ZERO
var snap_vector: Vector2 = SNAP_DIRECTION * SNAP_LENGTH
var stop_on_slope: bool = true
var move_direction: int = 0
var is_wall_sliding: bool = false
var ghost_move_direction: Vector2 = Vector2.ZERO
var carrying: Array = []
var recognizable_actionables = [ "Player", "Switch", "EnergyPlug" ]

## Flag de ayuda para saber identificar el estado de actividad
var dead: bool = false


func _ready() -> void:
	set_body_color(color)

func get_class(): return "Player"

func set_body_color(_color: Color):
	color = _color
	body_color.modulate = _color

## Se extrae el comportamiento del manejo del movimiento horizontal
## a una función para ser llamada apropiadamente desde la state machine
func _handle_horizontal_move_input() -> void:
	if !evaluate_inputs: return
	
	move_direction = int(Input.is_action_pressed("p"+id+"_move_right")) - int(Input.is_action_pressed("p"+id+"_move_left"))
	
	if move_direction != 0: 
		body_pivot.scale.x = 1 - 2 * float(move_direction < 0)
	
	added_velocity.x = move_direction * (ACCELERATION if is_on_floor() else AIR_ACCELERATION)


## Se extrae el comportamiento del manejo de la aplicación de fricción
## a una función para ser llamada apropiadamente desde la state machine
func _handle_deacceleration() -> void:
	added_velocity.x = -linear_velocity.x + lerp(linear_velocity.x, 0, FRICTION_WEIGHT if is_on_floor() else AIR_FRICTION_WEIGHT) if abs(linear_velocity.x) > 1 else -linear_velocity.x


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	velocity = state.linear_velocity
	
	velocity.y = clamp(velocity.y + added_velocity.y, -JUMP_SPEED_LIMIT, wall_slide_speed if is_wall_sliding else FALL_SPEED_LIMIT)
	velocity.x = clamp(velocity.x + added_velocity.x, -H_SPEED_LIMIT, H_SPEED_LIMIT)
	
	state.linear_velocity = velocity
	added_velocity = Vector2.ZERO
	


func _apply_ghost_movement(delta: float) -> void:
	if !evaluate_inputs: return
	
	ghost_move_direction.x = int(Input.is_action_pressed("p"+id+"_move_right")) - int(Input.is_action_pressed("p"+id+"_move_left"))
	ghost_move_direction.y = int(Input.is_action_pressed("p"+id+"_move_down")) - int(Input.is_action_pressed("p"+id+"_move_up"))
	if ghost_move_direction.x != 0:
		velocity.x = clamp(velocity.x + (ghost_move_direction.x * ACCELERATION), -GHOST_SPEED_LIMIT, GHOST_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0	
	if ghost_move_direction.y != 0:
		velocity.y = clamp(velocity.y + (ghost_move_direction.y * ACCELERATION), -GHOST_SPEED_LIMIT, GHOST_SPEED_LIMIT)
	else:
		velocity.y = lerp(velocity.y, 0, FRICTION_WEIGHT) if abs(velocity.y) > 1 else 0
	
	if ghost_move_direction.x != 0: 
		body_pivot.scale.x = 1 - 2 * float(ghost_move_direction.x < 0)
	
	position += velocity * delta
		

## Función que pisa la función is_on_floor() ya existente
## y le agrega el chequeo de raycasts para expandir la ventana
## de chequeo de piso
func is_on_floor() -> bool:
	var is_colliding: bool = false#.is_on_floor()
	for raycast in floor_raycasts:
		## Al tener deshabilitados los raycasts por default
		## ya que queremos que solamente se procesen en esta
		## función, debemos forzar una actualización
		raycast.force_raycast_update()
		is_colliding = is_colliding || raycast.is_colliding()
	return is_colliding

func is_on_wall() -> bool:
	var is_colliding: bool = false
	for raycast in wall_raycasts:
		raycast.force_raycast_update()
		is_colliding = is_colliding || raycast.is_colliding()
	return is_colliding

func notify_death() -> void:
	dead = true
	emit_signal("dead")

func notify_respawn() -> void:
	dead = false
	emit_signal("respawn")

func notify_goal_reached() -> void:
	state_machine.current_state.emit_signal("finished", "win")



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
	if body_animations.has_animation(animation) and body_animations.get_assigned_animation() != animation:
		body_animations.play(animation)
	if !body_animations.has_animation(animation):
		print("animation not found: '%s'." % [animation])

func get_current_animation() -> String:
	return body_animations.current_animation

func _on_animation_finished(anim_name: String = "") -> void:
	if anim_name == "action":
		_play_animation("idle")

var nearest_actionable: Actionable = null
onready var own_respawn_actionable = $RespawnActionable
signal nearest_actionable_changed(actionable)

func _unhandled_input(event: InputEvent) -> void:
	if !evaluate_inputs: return
	if event.is_action_pressed("p"+id+"_action"):
		get_viewport().set_input_as_handled()
		
		if is_instance_valid(nearest_actionable):
			_play_animation("action")
			
			body_pivot.scale.x = 1 - 2 * float((global_position - nearest_actionable.global_position).x > 0)
			
			nearest_actionable.emit_signal("actioned", self)


func check_nearest_actionable() -> void:
	if carrying:
		carrying[0].check_nearest_actionable(self)
	else:
		Utils.check_nearest_actionable(self, recognizable_actionables)


func _on_Player_nearest_actionable_changed(actionable: Node):
	if actionable != null:
		#print("nearest_actionable changed!! [%s]" % [actionable.name])
		action_alert.show()
		alert_sfx.play()
	else:
		action_alert.hide()
	nearest_actionable = actionable

