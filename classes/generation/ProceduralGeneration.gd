extends Node3D

@onready var player: CharacterBody3D = %ProtoController


func get_chunk() -> ChunkWithGen:
	return Scenes.CHUNK_WITH_GEN_SCENE.instantiate()


func add_chunk_on_map(chunk: Chunk, pos: Vector2i) -> void:
	Global.placed_chunk[pos] = chunk
	self.add_child.call_deferred(chunk)
	chunk.area_exited.connect(_on_chunk_with_gen_area_exited)

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


func show_chunk():
	for x in range(Constants.CHUNK_SHOWN * 2):
		x += (player.position.x / Constants.CHUNK_SIZE_X - Constants.CHUNK_SHOWN)
		for z in range(Constants.CHUNK_SHOWN * 2):
			z += (player.position.z / Constants.CHUNK_SIZE_Z - Constants.CHUNK_SHOWN)
			var pos : Vector2i = Vector2i(z, x)
			add_chunk_if_new(pos)
			print("add_chunk_if_new(pos)")
	
	print("TODO")

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
func generate_chuk():
	var _SIZE : int = Constants.CHUNK_SIZE * Constants.CHUNK_SHOWN
	for x in range(Constants.CHUNK_SHOWN * 2):
		x += (player.position.x / Constants.CHUNK_SIZE_X - Constants.CHUNK_SHOWN)
		for z in range(Constants.CHUNK_SHOWN * 2):
			z += (player.position.z / Constants.CHUNK_SIZE_Z - Constants.CHUNK_SHOWN)
			var pos : Vector2i = Vector2i(z, x)
			add_chunk_if_new(pos)

func _on_chunk_with_gen_area_exited(area: Area3D) -> void:
	generate_chuk()
#endregion


#region Start
func _process(delta: float) -> void:
	# TODO: Debug
	if(Input.is_action_just_pressed(Keybindings.DEBUG_KEY)):
		generate_chuk()
	pass

func _ready() -> void:
	if (PerlinNoise.noise == null):
		PerlinNoise.setup_noise()
	generate_chuk()
	#show_chunk()
#endregion
