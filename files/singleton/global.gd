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
