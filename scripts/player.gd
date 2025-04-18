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
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	handle_mouse_motion(delta)
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var movement_speed = RUN_SPEED if Input.is_action_pressed("run") else WALK_SPEED
	if direction:
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
	
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
