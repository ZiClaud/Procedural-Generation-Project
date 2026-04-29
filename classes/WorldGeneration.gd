extends Node3D

@export var tile1_ps: PackedScene
@export var tile2_ps: PackedScene

@export var tile1_weight: float = 1
@export var tile2_weight: float = 1

@export var world_size: int = 64

# Use load() instead of preload() if the path isn't known at compile-time.
#var scene = preload("res://scene.tscn").instantiate()
# Add the node as a child of the node the script is attached to.
#add_child(scene)

func _add_x_tiles():
	var x: int = -world_size / 2
	for i in world_size:
		var tile1: Node3D = tile1_ps.instantiate()
		tile1.position.x += x + i * 2
		
		self.add_child(tile1)


func _add_y_tiles():
	var z: int = -world_size / 2
	for k in world_size:
		var tile2: Node3D = tile2_ps.instantiate()
		tile2.position.z += z + k * 3.5
		
		self.add_child(tile2)


func _generate_x_6(tile: Node3D, x: float, z: float):
	pass

func _generation_base():
	var x: int = -world_size / 2
	var z: int = -world_size / 2
	for i in world_size:
		for k in world_size:
			var tile1: Node3D = tile1_ps.instantiate()
			tile1.position.x += x + i * 2
			tile1.position.z += z + k * 3.5
			
			self.add_child(tile1)
	
	for i in world_size:
		for k in world_size:
			var tile1: Node3D = tile2_ps.instantiate()
			tile1.position.x += x + i * 2 + 1
			tile1.position.z += z + k * 3.5 + 1.75
			
			self.add_child(tile1)
	


func _ready():
	_generation_base()
