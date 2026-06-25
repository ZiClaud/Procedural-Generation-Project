extends Node

# Global Singleton

var WORLD_SEED: int

var FREQ_DIVIDER: float = 64.0

var all_tiles_ps: Array[PackedScene] = []
# var placed: Array[Placable] = []
var placed_tile: Dictionary[Vector2i, MeshTile] = {}
var placed_chunk: Dictionary[Vector2i, Chunk] = {}

#region Utils
### Returns the true if it was found, false otherwise
func _does_tile_list_have_pos(pos: Vector2i) -> bool:
	return Global.placed_tile.has(pos)

### Returns the true if it was found, false otherwise
func _does_chunk_list_have_pos(pos: Vector2i) -> bool:
	return Global.placed_chunk.has(pos)
#endregion

#region Debug
const CODE_IMP_A_OPT: bool = true
const MULTI_THREAD_OPT: bool = true
const LOD_OPT: bool = true


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
