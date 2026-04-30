extends Node3D

@export var tile1_ps: PackedScene
@export var tile2_ps: PackedScene
@export var tile_debug1_ps: PackedScene
@export var tile_debug2_ps: PackedScene

@export var tile1_weight: float = 1
@export var tile2_weight: float = 1

@export var world_size: int = 32


func _add_x_tiles():
	var x: int = - world_size / 2
	for i in world_size:
		var tile1: Node3D = tile1_ps.instantiate()
		tile1.position.x += x + i * 2
		
		self.add_child(tile1)


func _add_y_tiles():
	var z: int = - world_size / 2
	for k in world_size:
		var tile2: Node3D = tile2_ps.instantiate()
		tile2.position.z += z + k * 3.5
		
		self.add_child(tile2)


func _generation_base():
	var x: int = 0
	var z: int = 0
	var flip: bool = true;
	for i in world_size:
		for k in world_size:
			var debug_tile: DebugTile = tile_debug1_ps.instantiate()
			if (flip):
				debug_tile.position.x += x + i * 2
				debug_tile.position.z += z + k * 1.75
			else:
				debug_tile.position.x += x + i * 2 + 1
				debug_tile.position.z += z + k * 1.75
			
			debug_tile.pos_x = k
			debug_tile.pos_y = 0
			debug_tile.pos_z = i
			
			debug_tile.txt = "".join([
				"x = ", String.num_int64(debug_tile.position.x),
				", y = ",
				String.num_int64(debug_tile.position.y),
				", z = ",
				String.num_int64(debug_tile.position.z)
			])
			
			flip = !flip
			self.add_child(debug_tile)


func _ready():
	_generation_base()
