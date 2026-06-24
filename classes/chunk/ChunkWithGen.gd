class_name ChunkWithGen
extends Chunk

#region Terrain population
func add_on_map(tile: Placable, pos: Vector2i) -> void:
	Global.placed_tile[pos] = tile
	tile.set_process(false)
	tile.set_physics_process(false)
	# TODO: self.add_child(tile) ?
	get_parent().add_child(tile)

func set_tile_pos(tile: MeshTile, pos: Vector2i) -> bool:
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
	var row: int = pos.x
	var col: int = pos.y
	
	if (row % 2):
		tile.position.x = col * Constants.TILE_SIZE_X
		tile.position.z = row * Constants.TILE_SIZE_Z
	else:
		tile.position.x = col * Constants.TILE_SIZE_X + (Constants.TILE_SIZE_X / 2)
		tile.position.z = row * Constants.TILE_SIZE_Z
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
		assert(false, "PerlinNoise.noise == null")
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
			add_on_map(tile, pos)
		else:
			assert(false, "Tile not added for some reason")
		return
	#print("Tile not added")
#endregion

func _ready() -> void:
	#PerlinNoise.setup_noise()
	for x in range(self.position.x, self.position.x + Constants.CHUNK_SIZE):
		for z in range(self.position.z, self.position.z + Constants.CHUNK_SIZE):
			add_tile_if_new(Vector2i(z, x))
	super._ready()
