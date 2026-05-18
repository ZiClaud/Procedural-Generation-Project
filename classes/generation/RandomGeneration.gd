class_name RandomGeneration
extends BaseGeneration

func _fill_world_with_debug():
	for col in world_size:
		for row in world_size:
			var tile: DebugTile = DEBUG_TILE_SCENE.instantiate()
			
			set_tile_pos(tile, Vector2i(row, col))
			
			# DEBUG TILE tile.txt = String.num_int64(i)
			_add_ui_debug_tile(tile, "")
			
			await add_on_map(tile)


func _fill_world_random():
	var used: Array[Vector2] = []
	var max_tiles: int = world_size * world_size
	for i in max_tiles:
		var rand_pos: Vector2i = Vector2i(randi() % world_size, randi() % world_size)
		if (used.has(rand_pos)):
			continue
		
		var tile: BaseTile = get_random_tile()
		set_tile_pos(tile, rand_pos)
		used.append(rand_pos)
		self.add_child(tile)


func _fill_world_with_rules(n_iterations: int):
	for col in world_size:
		for row in world_size:
			for curr_iteration in n_iterations:
				var tile: BaseTile = get_random_tile()
				set_tile_pos(tile, Vector2i(row,col))
				if (can_tile_be_placed(placed, tile)):
					placed.append(tile)
					await add_on_map(tile)
					break


func _fill_world_random_with_rules():
	var num_iterations: int = world_size * world_size
	for i in num_iterations:
		var rand_pos: Vector2i = Vector2i(randi() % world_size, randi() % world_size)
		
		if (_does_list_have_pos(placed, rand_pos) != null):
			continue
		
		var tile: BaseTile = get_random_tile()
		set_tile_pos(tile, rand_pos)
		if (can_tile_be_placed(placed, tile)):
			placed.append(tile)
			await add_on_map(tile)


func _fill_world_with_rules_and_rotation():
	for col in world_size:
		for row in world_size:
			var tile: BaseTile = get_random_tile()
			add_tile_to_map_or_rotate_it(tile, Vector2i(row, col))


func _fill_world_with_rules_and_rotation_2(n_iterations: int):
	var is_placed: bool
	for col in world_size:
		for row in world_size:
			is_placed = false
			for curr_iteration in n_iterations:
				var tile: BaseTile = get_random_tile()
				set_tile_pos(tile, Vector2i(row,col))
				is_placed = await add_tile_to_map_or_rotate_it(tile, Vector2i(row, col))
				if(is_placed):
					break


func generation(gen_mode: GenerationMode) -> void:
	generation_mode = gen_mode
	
	if (gen_mode == GenerationMode.DEBUG):
		_fill_world_with_debug()
	elif (gen_mode == GenerationMode.RANDOM):
		_fill_world_random()
	elif (gen_mode == GenerationMode.RULED):
		_fill_world_with_rules(10) # Best
	elif (gen_mode == GenerationMode.RULED_RANDOM):
		_fill_world_random_with_rules()
	elif (gen_mode == GenerationMode.RULED_RANDOM_ROTATION):
		_fill_world_with_rules_and_rotation()
	elif (gen_mode == GenerationMode.BETTER_RULED_RANDOM_ROTATION):
		_fill_world_with_rules_and_rotation_2(3) # New Best
	elif (gen_mode == GenerationMode.ERROR):
		assert(false, "GenerationMode.ERROR")
	else:
		assert(false, "Generation random type not found")


func _ready():
	super._ready()
	generation(GenerationMode.BETTER_RULED_RANDOM_ROTATION)
