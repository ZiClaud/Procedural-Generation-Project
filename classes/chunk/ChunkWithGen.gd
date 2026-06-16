class_name ChunkWithGen
extends Chunk

var matrix_pos: Vector2i
var is_generated: bool = false

#region Terrain population
func add_on_map(tile: MeshTile) -> void:
	Global.placed.append(tile)
	self.add_child(tile)

func set_tile_pos(tile: MeshTile, pos: Vector2i) -> bool:
	tile.matrix_pos = pos
	
	var row: int = pos.x
	var col: int = pos.y
	
	if (row % 2):
		tile.position.x = col * Constants.TILE_SIZE_X
		tile.position.z = row * Constants.TILE_SIZE_Z
	else:
		tile.position.x = col * Constants.TILE_SIZE_X + 1
		tile.position.z = row * Constants.TILE_SIZE_Z
	return true

func set_tile_pos_3d(tile: MeshTile, pos: Vector2i, height: float) -> bool:
	tile.matrix_pos = pos
	
	var row: int = pos.x
	var col: int = pos.y
	
	if (row % 2):
		tile.position.x = col * 2
		tile.position.z = row * 1.75
	else:
		tile.position.x = col * 2 + 1
		tile.position.z = row * 1.75
	tile.position.y = height * Constants.HEIGHT_MULTIPLIER
	if (height < 0):
		tile.position.y = 0
	return true

# Returns new true if it was created, false otherwise
func set_tile_pos_3d_if_new(tile: MeshTile, pos: Vector2i, height: float) -> bool:
	if Global._does_tile_list_have_pos(pos) == false:
		return set_tile_pos_3d(tile, pos, height)
	return false
#endregion

#region Tile
func get_perlin_height(pos: Vector2i) -> float:
	if (PerlinNoise.noise == null):
		return 0
	return PerlinNoise.noise.get_noise_2dv(pos)

func get_tile_colored(height) -> MeshTile:
	var mesh_tile: MeshTile = _get_tile()
	
	mesh_tile.color_self_height(height)
	
	return mesh_tile

func _get_tile() -> MeshTile:
	return Scenes.MESH_TILE_SCENE.instantiate()
#endregion

#region Adding on the map
func add_tile_if_new(pos: Vector2i) -> void:
	if (Global._does_tile_list_have_pos(pos) == false):
		var height: float = get_perlin_height(pos)
		var tile: MeshTile = get_tile_colored(height)
		#print("Tile added")
		if(set_tile_pos_3d_if_new(tile, pos, height)):
			add_on_map(tile)
		else:
			assert(false, "Tile not added for some reason")
		return
	#print("Tile not added")
#endregion


func _ready() -> void:
	#PerlinNoise.setup_noise()
	for x in Constants.CHUNK_SIZE:
		for z in Constants.CHUNK_SIZE:
			add_tile_if_new(Vector2i(x, z))
