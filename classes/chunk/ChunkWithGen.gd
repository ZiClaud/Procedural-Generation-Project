class_name ChunkWithGen
extends Chunk

#region Terrain population
func add_on_map(tile: Placable, pos: Vector2i) -> void:
	Global.placed_tile[pos] = tile
	Global.n_tiles += 1
	tile.set_process(false)
	tile.set_physics_process(false)
	#self.add_child(tile) # TODO: Check this out, important
	get_parent().add_child(tile)

func set_tile_pos(tile: MeshTile, pos: Vector2i) -> bool:
	var row: int = pos.x
	var col: int = pos.y
	
	if (row % 2):
		tile.position.x = row * Constants.TILE_SIZE_X
		tile.position.z = col * Constants.TILE_SIZE_Z
	else:
		tile.position.x = row * Constants.TILE_SIZE_X + 1
		tile.position.z = col * Constants.TILE_SIZE_Z
	return true

func set_tile_pos_3d(tile: MeshTile, pos: Vector2i, height: float) -> bool:
	var row: int = pos.x
	var col: int = pos.y
	
	if (row % 2):
		tile.position.x = row * Constants.TILE_SIZE_X
		tile.position.z = col * Constants.TILE_SIZE_Z
	else:
		tile.position.x = row * Constants.TILE_SIZE_X + (Constants.TILE_SIZE_X / 2)
		tile.position.z = col * Constants.TILE_SIZE_Z
	tile.position.y = height
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
	return PerlinNoise.noise.get_noise_2dv(pos) * Constants.HEIGHT_MULTIPLIER

func get_perlin_height_optimized(pos: Vector2i) -> float:
	if (PerlinNoise.noise == null):
		assert(false, "PerlinNoise.noise == null")
	
	return PerlinNoise.noise.get_noise_2dv(pos) * Constants.HEIGHT_MULTIPLIER

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
		if(set_tile_pos_3d_if_new(tile, pos, height)):
			add_on_map(tile, pos)
		else:
			assert(false, "Tile not added for some reason")
		return


var data: Array[Vector3] = []

func add_tile_if_new_optimized(pos: Vector2i) -> void:
	if (Global._does_tile_list_have_pos(pos) == false):
		var height: float = get_perlin_height_optimized(pos)
		data.append(Vector3(pos.x, height, pos.y))
		#TODO Global.placed_tile_optimized[pos] = 
		Global.n_tiles += 1
#endregion

func _ready() -> void:
	#PerlinNoise.setup_noise()
	var logger = ChunkManagerLogger.new()
	logger.state = ChunkManagerLogger.State.MESH  # or BOTH, FPS, NONE
	logger.enable_logging(self)  # Pass 'self' as the Node parent
	
	logger.start_time_log()
	
	var tick_start := Time.get_ticks_usec()
	
	for x in range(self.position.x, self.position.x + Constants.CHUNK_SIZE):
		for z in range(self.position.z, self.position.z + Constants.CHUNK_SIZE):
			if (Global.MULTI_MESH_OPT):
				add_tile_if_new_optimized(Vector2i(x, z))
			else:
				add_tile_if_new(Vector2i(x, z))
	super._ready()
	
	var tick_end := Time.get_ticks_usec()
	var gen_time := (tick_end - tick_start) / 1000000.0
	Global.all_gen_times.append(gen_time)
	#Global.print_average_gen_time() # TODO - Comment

	var multi_mesh_instance: MultiMeshInstance3D = %MultiMeshInstance3D
	multi_mesh_instance.multimesh = multi_mesh_instance.multimesh.duplicate()
	multi_mesh_instance.multimesh.instance_count = data.size()
	
	for i in range(data.size()):
		data[i].x = data[i].x - self.position.x
		data[i].z = data[i].z - self.position.z
		if (data[i].y < 0):
			data[i].y = 0
	for i in range(multi_mesh_instance.multimesh.instance_count):		
		multi_mesh_instance.multimesh.set_instance_transform(i, Transform3D(Basis(), data[i]))
		multi_mesh_instance.multimesh.set_instance_color(i, Global.get_color_from_height(data[i].y))
	
	logger.end_time_log(self, self.position)
