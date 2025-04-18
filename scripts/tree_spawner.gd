class_name TreeSpawner
extends Node3D

@export var tree_scene: PackedScene
@export var planting_area := Vector2(500.0, 500.0)
@export var tree_count := 2500
@export var minimum_distance_between_trees := 7.5
@export var player: Player

# ---------------------------------------------------------------------------

func _ready():
	spawn_trees()

# ---------------------------------------------------------------------------

func spawn_trees() -> void:
	var tree_positions: Array[Vector3] = []
	
	for i in tree_count:
		var planting_position: Vector3
		
		# Inefficient loop to make sure trees aren't too close to each other or the player
		var is_planting_position_found := false
		while not is_planting_position_found:
			planting_position = Vector3(
				randf_range(-planting_area.x / 2.0, planting_area.x / 2.0),
				0.0,
				randf_range(-planting_area.y / 2.0, planting_area.y / 2.0),
			)
			
			if planting_position.distance_to(player.position) < minimum_distance_between_trees:
				continue
			
			is_planting_position_found = true
			
			for other_tree_position in tree_positions:
				if planting_position.distance_to(other_tree_position) < minimum_distance_between_trees:
					is_planting_position_found = false
					break
		
		tree_positions.append(planting_position)
	
	for tree_position in tree_positions:
		var tree := tree_scene.instantiate() as BotwLodTree
		tree.position = tree_position
		tree.rotate_y(randi_range(0, 359))
		tree.player = player
		
		add_child(tree)
