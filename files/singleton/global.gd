extends Node

# Global Singleton

var WORLD_SEED: int

var FREQ_DIVIDER: float = 64.0

var all_tiles_ps: Array[PackedScene] = []
var placed: Array[MeshTile] = []
var placed_chunk: Array[Chunk] = []

#region Utils
### Returns the true if it was found, false otherwise
func _does_tile_list_have_pos(pos: Vector2i) -> bool:
	for tile in Global.placed:
		if(tile.matrix_pos == pos):
			return true
	return false

### Returns the true if it was found, false otherwise
func _does_chunk_list_have_pos(pos: Vector2i) -> bool:
	for chunk in Global.placed_chunk:
		if(chunk.matrix_pos == pos):
			return true
	return false
#endregion
