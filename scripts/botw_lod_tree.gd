class_name BotwLodTree
extends Node3D

@onready var model := $Model
@onready var billboard := $Billboard

const BILLBOARD_ACTIVIATION_DISTANCE := 50.0

# ---------------------------------------------------------------------------

func _ready():
	model.visible = false
	billboard.visible = true

# ---------------------------------------------------------------------------

func _process(delta):
	var distance_to_camera := calculate_distance_to_camera()
	if distance_to_camera >= BILLBOARD_ACTIVIATION_DISTANCE:
		model.visible = false
		billboard.visible = true
	else:
		model.visible = true
		billboard.visible = false

# ---------------------------------------------------------------------------

func calculate_distance_to_camera() -> float:
	var camera_position := get_viewport().get_camera_3d().global_position
	return self.global_position.distance_to(camera_position)
