extends Node3D

@onready var player: CharacterBody3D = %ProtoController


func get_chunk() -> ChunkWithGen:
	return Scenes.CHUNK_WITH_GEN_SCENE.instantiate()

var all_chunks: int = 0
var all_tiles: int = 0

func add_chunk_on_map(chunk: Chunk, pos: Vector2i) -> void:
	Global.placed_chunk[pos] = chunk
	chunk.set_process(false)
	chunk.set_physics_process(false)
	self.add_child.call_deferred(chunk)
	chunk.area_exited.connect(_on_chunk_with_gen_area_exited)
	all_chunks += 1
	all_tiles += 256

func set_chunk_pos(chunk: Chunk, pos: Vector2i) -> bool:
	var row: int = pos.x * Constants.CHUNK_SIZE_Z
	var col: int = pos.y * Constants.CHUNK_SIZE_X
	
	chunk.position.x = col
	chunk.position.z = row
	return true

# Returns new true if it was created, false otherwise
func set_chunk_pos_if_new(chunk: Chunk, pos: Vector2i) -> bool:
	if Global._does_chunk_list_have_pos(pos) == false:
		return set_chunk_pos(chunk, pos)
	return false

#region Adding on the map
func add_chunk_if_new(pos: Vector2i) -> void:
	if (Global._does_chunk_list_have_pos(pos) == false):
		var chunk: Chunk = get_chunk()

		if(set_chunk_pos_if_new(chunk, pos)):
			add_chunk_on_map(chunk, pos)
		else:
			assert(false, "Tile not added for some reason")
		return
	#print("Tile not added")
#endregion


#region Chunks


#func show_chunk():
	#for x in range(Constants.CHUNK_SHOWN * 2):
		#x += (player.position.x / Constants.CHUNK_SIZE_X - Constants.CHUNK_SHOWN)
		#for z in range(Constants.CHUNK_SHOWN * 2):
			#z += (player.position.z / Constants.CHUNK_SIZE_Z - Constants.CHUNK_SHOWN)
			#var pos : Vector2i = Vector2i(z, x)
			#add_chunk_if_new(pos)
			#print("add_chunk_if_new(pos)")
	#
	#print("TODO")

func idk():
	# Place an Area2D, when the player is in, it will generate the next area
	pass
#endregion

#region Partial classes
func generation() -> void:
	assert(false, "Function 'generation' not implemented")

#func generate_from_player_position():
#	assert(false, "Function 'generate_from_player_position' not implemented")

#func generate_from_player_position():
	#var _SIZE : int = Constants.CHUNK_SIZE * Constants.CHUNK_SHOWN
	#for x in range(_SIZE * 2):
		#x += (player.position.x / Constants.TILE_SIZE_X - _SIZE)
		#for z in range(_SIZE * 2):
			#z += (player.position.z / Constants.TILE_SIZE_Z - _SIZE)
			#var pos : Vector2i = Vector2i(z, x)
			##add_tile_if_new(pos)
#endregion

#region Chunk
#func generate_chuk():
	#var _SIZE : int = Constants.CHUNK_SIZE * Constants.CHUNK_SHOWN
	#for x in range(Constants.CHUNK_SHOWN):
		#x += (player.position.x / Constants.CHUNK_SIZE_X - Constants.CHUNK_SHOWN)
		#for z in range(Constants.CHUNK_SHOWN):
			#z += (player.position.z / Constants.CHUNK_SIZE_Z - Constants.CHUNK_SHOWN)
			#var pos : Vector2i = Vector2i(z, x)
			#add_chunk_if_new(pos)


func generate_chunk():
	# Find which chunk the player is currently in
	var player_chunk_x : int = int(player.position.x / Constants.CHUNK_SIZE_X)
	var player_chunk_z : int = int(player.position.z / Constants.CHUNK_SIZE_Z)
	
	# Define how far around the player to generate (radius in chunks)
	var half : int = Constants.CHUNK_SHOWN / 2
	
	for x in range(-half, half + 1):
		for z in range(-half, half + 1):
			var pos : Vector2i = Vector2i(
				player_chunk_z + z,
				player_chunk_x + x,
			)
			add_chunk_if_new(pos)

func _on_chunk_with_gen_area_exited(area: Area3D) -> void:
	generate_chunk()
#endregion


#region Start
#func _process(delta: float) -> void:
	## TODO: Debug
	#if(Input.is_action_just_pressed(Keybindings.DEBUG_KEY)):
		#generate_chunk()
	#pass

func _ready() -> void:
	print_debug("----- Chunk Sizes -----\nCHUNK_SIZE: %s\nCHUNK_SHOWN: %s" % [Constants.CHUNK_SIZE, Constants.CHUNK_SHOWN])
	
	Performance.add_custom_monitor("game/chunks", func(): return all_chunks)
	Performance.add_custom_monitor("game/placed_chunks", func(): return Global.placed_chunk.size())
	Performance.add_custom_monitor("game/tiles", func(): return all_tiles)
	
	var tick_start := Time.get_ticks_usec()
	
	if (PerlinNoise.noise == null):
		PerlinNoise.setup_noise()
	generate_chunk()
	
	var tick_end := Time.get_ticks_usec()
	var gen_time := (tick_end - tick_start) / 1000000.0
	print_debug("--- ProceduralGenWorld ---\nBlocks: %s\nGen Time: %s" % [Global.n_tiles, gen_time])


#endregion
