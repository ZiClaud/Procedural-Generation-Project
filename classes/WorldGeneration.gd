extends Node3D

@export var all_tiles_ps: Array[PackedScene] = []
@export var tiles_weight: Array[int] = []

@export var world_size: int = 32

func _add_ui_debug_tile(tile: BaseTile, row: int, col: int):
	# TODO assert(tile.is_class("DebugTile"))
	tile.pos_x = row
	tile.pos_y = 0
	tile.pos_z = col
	
	tile.txt = "".join([
		"x = ", String.num_int64(tile.position.x),
		", y = ",
		String.num_int64(tile.position.y),
		", z = ",
		String.num_int64(tile.position.z),
		"row = ",
		String.num_int64(row),
	])


func _generation_base():
	var x: int = 0
	var z: int = 0
	var flip: bool = true;
	for col in world_size:
		for row in world_size:
			var tile: DebugTile = all_tiles_ps.front().instantiate()
			if (flip):
				tile.position.x += x + col * 2
				tile.position.z += z + row * 1.75
			else:
				tile.position.x += x + col * 2 + 1
				tile.position.z += z + row * 1.75
			
			_add_ui_debug_tile(tile, row, col)
			
			flip = !flip
			self.add_child(tile)


func _ready():
	assert(all_tiles_ps.size() == tiles_weight.size())
	_generation_base()
