class_name BotwLodTree
extends Node3D

@onready var model := $Model
@onready var billboard := $Billboard

const BILLBOARD_ACTIVIATION_DISTANCE := 100.0

# ---------------------------------------------------------------------------

func _ready():
	model.visible = false
	billboard.visible = true

# ---------------------------------------------------------------------------

func _process(_delta):
	var lateral_distance_to_camera := calculate_lateral_distance_to_camera()
	if lateral_distance_to_camera >= BILLBOARD_ACTIVIATION_DISTANCE:
		model.visible = false
		billboard.visible = true
	else:
		model.visible = true
		billboard.visible = false
	
	# Uncomment this section to enable manual lod toggling (and comment the above too!)
	#if Input.is_action_just_pressed("debug_toggle_lod"):
		#print(calculate_distance_to_camera())
		#if model.visible:
			#model.visible = false
			#billboard.visible = true
		#else:
			#model.visible = true
			#billboard.visible = false

# ---------------------------------------------------------------------------

func calculate_lateral_distance_to_camera() -> float:
	var my_position := global_position
	my_position.y = 0.0
	
	var camera_position := get_viewport().get_camera_3d().global_position
	camera_position.y = 0.0
	
	return self.global_position.distance_to(camera_position)
