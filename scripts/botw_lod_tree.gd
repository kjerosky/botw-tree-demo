class_name BotwLodTree
extends StaticBody3D

@export var player: Player
@export var diffuse_textures: Array[Texture2D]
@export var normal_textures: Array[Texture2D]

@onready var model := $Model
@onready var billboard := $Billboard
@onready var billboard_material := billboard.get_surface_override_material(0) as StandardMaterial3D
@onready var collider := $CollisionShape3D

const BILLBOARD_ACTIVIATION_DISTANCE := 100.0

var billboard_image_index := 0

# ---------------------------------------------------------------------------

func _ready():
	use_billboard()

# ---------------------------------------------------------------------------

func _process(_delta):
	var lateral_distance_to_camera := calculate_lateral_distance_to_camera()
	if lateral_distance_to_camera >= BILLBOARD_ACTIVIATION_DISTANCE:
		use_billboard()
	else:
		use_model()
	
	# Uncomment this section and comment out the one above to enable manual lod toggling
	#if Input.is_action_just_pressed("debug_toggle_lod"):
		#print(calculate_lateral_distance_to_camera())
		#if model.visible:
			#use_billboard()
		#else:
			#use_model()
	
	var angle_from_player_to_tree := rad_to_deg((-self.basis.z).signed_angle_to(self.global_position - player.global_position, Vector3.DOWN))
	if angle_from_player_to_tree < 0.0:
		angle_from_player_to_tree = 360.0 + angle_from_player_to_tree
	
	# Adjust the angle so a 45 degree field is created around each major angle increment (0, 45, 90, 135, etc.)
	var adjusted_angle := roundi(angle_from_player_to_tree + 45 / 2.0)
	if adjusted_angle >= 360:
		adjusted_angle -= 360
	
	var new_billboard_image_index := adjusted_angle / 45
	if new_billboard_image_index != billboard_image_index:
		billboard_image_index = new_billboard_image_index
		update_billboard_material()

# ---------------------------------------------------------------------------

func calculate_lateral_distance_to_camera() -> float:
	var my_position := global_position
	my_position.y = 0.0
	
	var camera_position := get_viewport().get_camera_3d().global_position
	camera_position.y = 0.0
	
	return self.global_position.distance_to(camera_position)

# ---------------------------------------------------------------------------

func update_billboard_material() -> void:
	billboard_material.albedo_texture = diffuse_textures[billboard_image_index]
	billboard_material.normal_texture = normal_textures[billboard_image_index]

# ---------------------------------------------------------------------------

func use_billboard() -> void:
	model.visible = false
	billboard.visible = true
	collider.disabled = true

# ---------------------------------------------------------------------------

func use_model() -> void:
	model.visible = true
	billboard.visible = false
	collider.disabled = false
