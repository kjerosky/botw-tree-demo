class_name Player
extends CharacterBody3D

@onready var camera = $Camera

const WALK_SPEED = 5.0
const RUN_SPEED = 15.0

var mouse_motion := Vector2.ZERO

# ---------------------------------------------------------------------------

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# ---------------------------------------------------------------------------

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_motion = event.relative

# ---------------------------------------------------------------------------

func _physics_process(delta):
	if Input.is_action_just_pressed("debug_quit"):
		get_tree().quit()
	
	handle_mouse_motion(delta)
	
	var movement_speed = RUN_SPEED if Input.is_action_pressed("run") else WALK_SPEED
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
	
	var vertical_direction = (1.0 if Input.is_action_pressed("move_up") else 0.0) - (1.0 if Input.is_action_pressed("move_down") else 0.0)
	if vertical_direction:
		velocity.y = vertical_direction * movement_speed
	else:
		velocity.y = vertical_direction * movement_speed
	
	move_and_slide()

# ---------------------------------------------------------------------------

func handle_mouse_motion(delta: float) -> void:
	if mouse_motion == Vector2.ZERO:
		return
	
	rotate_y(-mouse_motion.x * delta)
	rotation_degrees.y = wrap(rotation_degrees.y, 0.0, 360.0)
	
	camera.rotate_x(mouse_motion.y * delta)
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -89.0, 89.0)
	
	mouse_motion = Vector2.ZERO
