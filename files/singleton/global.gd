extends Node

# Global Singleton

var WORLD_SEED: int

var FREQ_DIVIDER: float = 64.0

var all_tiles_ps: Array[PackedScene] = []
# var placed: Array[Placable] = []
var placed_tile: Dictionary[Vector2i, MeshTile] = {}
var placed_tile_optimized: Dictionary[Vector2i, Color] = {}
var placed_chunk: Dictionary[Vector2i, Chunk] = {}

#region Utils
### Returns the true if it was found, false otherwise
func _does_tile_list_have_pos(pos: Vector2i) -> bool:
	return Global.placed_tile.has(pos)

### Returns the true if it was found, false otherwise
func _does_chunk_list_have_pos(pos: Vector2i) -> bool:
	return Global.placed_chunk.has(pos)
#endregion

#region Tiles Color
enum types {
	WATER,
	GRASS,
	SNOW,
	SAND,
}

func _get_color_from_type(type: types):
	if (type == types.WATER):
		return Color("#89dceb") #, 0.8)
	elif (type == types.GRASS):
		return Color("#a6e3a1")
	elif (type == types.SNOW):
		return Color("#cdd6f4")
	elif (type == types.SAND):
		return Color("#f9e2af")
	else:
		assert(false, "Not colour type fround")

func _get_type_from_height(height: float):
	if (height <= 0):
		return types.WATER
	elif (height < 0.5):
		return types.SAND
	elif (height < 7.5):
		return types.GRASS
	else:
		return types.SNOW


func get_color_from_height(height: float):
	return _get_color_from_type(_get_type_from_height(height))
#endregion

#region Debug
# Generation optimazions
const CODE_IMP_A_OPT: bool = true
const CODE_IMP_B_OPT: bool = true
const HASHMAP_OPT: bool = true # Using dictioanries
const MULTI_THREAD_OPT: bool = true
const MULTI_MESH_OPT : bool = true
# const MESH_POOLING_OPT : bool = true - too difficult to implement alongside with MULTI_MESH_OPT

# Runtime optimations
const LOD_OPT: bool = true # & Visibility Range
const OCCLUSION_CULLING_OPT : bool = true

var n_tiles: int = 0

var all_gen_times: Array[float] = []

func print_average_gen_time():
	var sum : float = 0
	for gen_time in all_gen_times:
		sum += gen_time
	
	print("Average gen time per chunk: %.9f; \tplaced tiles: %s" % [sum/all_gen_times.size(), n_tiles])
	
	if (n_tiles == 2304 || n_tiles == 6400):
		print_all_gen_time()

func print_all_gen_time():
	var sum : float = 0
	for gen_time in all_gen_times:
		sum += gen_time
	
	print("Complete gen time per chunk: %.9f; \tplaced tiles: %s" % [sum, n_tiles])
#endregion
