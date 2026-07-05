extends Node3D

@onready var player: CharacterBody3D = %ProtoController


func get_chunk() -> ChunkWithGen:
	return Scenes.CHUNK_WITH_GEN_SCENE.instantiate()

var all_chunks: int = 0
var all_tiles: int = 0

func add_chunk_on_map(chunk: Chunk, pos: Vector2i) -> void:
	Global.placed_chunk[pos] = chunk
	if (Global.REMOVE_TILE_PROCESS_OPT):
		chunk.set_process(false)
		chunk.set_physics_process(false)
	self.add_child.call_deferred(chunk)
	chunk.area_exited.connect(_on_chunk_with_gen_area_exited)
	all_chunks += 1
	all_tiles += 256

func set_chunk_pos(chunk: Chunk, pos: Vector2i) -> bool:
	var row: int = pos.x * Constants.CHUNK_SIZE_X
	var col: int = pos.y * Constants.CHUNK_SIZE_Z
	
	chunk.position.x = row
	chunk.position.z = col
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
				player_chunk_x + x,
				player_chunk_z + z,
			)
			add_chunk_if_new(pos)

func _on_chunk_with_gen_area_exited(area: Area3D) -> void:
	generate_chunk()
#endregion

#region Threaded Gen
var generation_thread: Thread

func generate_chunk_threaded(player_pos: Vector3):
	var tick_start := Time.get_ticks_usec()
	
	var player_chunk_x : int = int(player_pos.x / Constants.CHUNK_SIZE_X)
	var player_chunk_z : int = int(player_pos.z / Constants.CHUNK_SIZE_Z)
	
	var half : int = Constants.CHUNK_SHOWN / 2
	var chunks_to_add = []
	
	for x in range(-half, half + 1):
		for z in range(-half, half + 1):
			var pos : Vector2i = Vector2i(
				player_chunk_z + z,
				player_chunk_x + x,
			)
			chunks_to_add.append(pos)
	
	# Defer adding chunks back to main thread
	call_deferred("_add_chunks_main_thread", chunks_to_add, tick_start)

func _add_chunks_main_thread(chunks_to_add: Array, tick_start: int):
	for pos in chunks_to_add:
		add_chunk_if_new(pos)
	
	var tick_end := Time.get_ticks_usec()
	var gen_time := (tick_end - tick_start) / 1000000.0
	#print_debug("--- ProceduralGenWorld ---\nBlocks: %s\nGen Time: %s" % [Global.n_tiles, gen_time])
#endregion

#region Threaded Gen (4 threads)
var generation_threads: Array[Thread] = []

func generate_chunk_4_threaded() -> void:
	var player_pos := player.position
	var player_chunk_x := int(player_pos.x / Constants.CHUNK_SIZE_X)
	var player_chunk_z := int(player_pos.z / Constants.CHUNK_SIZE_Z)
	var half := Constants.CHUNK_SHOWN / 2
	
	# Build the full list of positions
	var all_positions: Array[Vector2i] = []
	for x in range(-half, half + 1):
		for z in range(-half, half + 1):
			all_positions.append(Vector2i(
				player_chunk_z + z,
				player_chunk_x + x,
			))
	
	# Split into 4 buckets
	var buckets: Array = [[], [], [], []]
	for i in range(all_positions.size()):
		buckets[i % 4].append(all_positions[i])
	
	var tick_start := Time.get_ticks_usec()
	var results_mutex := Mutex.new()
	var merged_results: Array[Vector2i] = []
	var threads_done := 0
	var done_mutex := Mutex.new()
	
	for i in range(4):
		var t := Thread.new()
		generation_threads.append(t)
		t.start(_worker_thread.bind(buckets[i], results_mutex, merged_results))
	
	# Poll until all threads finish, then flush to main thread
	# (use a timer or _process to avoid blocking)
	_wait_and_flush(tick_start, merged_results)

func _worker_thread(positions: Array, mtx: Mutex, results: Array) -> void:
	# Pure data work only — NO Godot scene/node calls here
	var local: Array[Vector2i] = []
	for pos in positions:
		if not Global._does_chunk_list_have_pos(pos):
			local.append(pos)
	mtx.lock()
	results.append_array(local)
	mtx.unlock()

func _wait_and_flush(tick_start: int, results: Array[Vector2i]) -> void:
	for t in generation_threads:
		t.wait_to_finish()   # blocks briefly, but threads are nearly done
	generation_threads.clear()
	_add_chunks_main_thread(results, tick_start)
#endregion

#region Start
#func _process(delta: float) -> void:
	## TODO: Debug
	#if(Input.is_action_just_pressed(Keybindings.DEBUG_KEY)):
		#generate_chunk()
	#pass

func _ready() -> void:
	#print_debug("----- Chunk Sizes -----\nCHUNK_SIZE: %s\nCHUNK_SHOWN: %s" % [Constants.CHUNK_SIZE, Constants.CHUNK_SHOWN])
	
	Performance.add_custom_monitor("game/chunks", func(): return all_chunks)
	Performance.add_custom_monitor("game/placed_chunks", func(): return Global.placed_chunk.size())
	Performance.add_custom_monitor("game/tiles", func(): return all_tiles)
	
	if (PerlinNoise.noise == null):
		PerlinNoise.setup_noise()
	
	
	if (Global.MULTI_THREAD_OPT):
		# Multi thread - 4
		generate_chunk_4_threaded()
		#generation_thread = Thread.new()
		#var pos := player.position
		#generation_thread.start(generate_chunk_threaded.bind(pos))
	else:
		# Single thread
		generate_chunk()
	
	
	var tick_start := Time.get_ticks_usec()
	var tick_end := Time.get_ticks_usec()
	var gen_time := (tick_end - tick_start) / 1000000.0
	#print_debug("--- ProceduralGenWorld ---\nBlocks: %s\nGen Time: %s" % [Global.n_tiles, gen_time])
#endregion
