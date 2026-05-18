class_name ProceduralGeneration
extends BaseGeneration

var noise: FastNoiseLite

func setup_noise():
	var seed: int = randi()
	print("Seed: ", seed)
	
	var freq: float = 1 / world_middle
	print("Freq: ", freq)

	noise = FastNoiseLite.new()

	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.seed = seed
	noise.frequency = freq


func get_perlin_height(pos: Vector2i) -> float:
	return noise.get_noise_2dv(pos)

func get_perlin_tile(row: int, col: int) -> BaseTile:
	var noise_val : float = get_perlin_height(Vector2i(row, col))
	
	if (noise_val >= 0):
		return GRASS_TILE_SCENE.instantiate()
	else:
		return WATER_TILE_SCENE.instantiate()


func _fill_world_not_perlin_noise() -> void:
	for col in world_size:
		for row in world_size:
			var tile: BaseTile = get_random_tile()
			set_tile_pos(tile, Vector2i(row, col))
			placed.append(tile)
			await add_on_map(tile)


func _fill_world_perlin_noise() -> void:
	setup_noise()
	for col in world_size:
		for row in world_size:
			var tile: BaseTile = get_perlin_tile(row, col)
			set_tile_pos(tile, Vector2i(row, col))
			placed.append(tile)
			await add_on_map(tile)


func _try_to_place_coast(pos: Vector2i) -> bool:
	for tile in COASTS_TILES_SCENE:
		var t: BaseTile = tile.instantiate()
		var was_placed: bool = await add_tile_to_map_or_rotate_it(t, pos)
		if (was_placed):
			return true
	
	# Try to place water/grass if no coast was found
	var t: BaseTile = GRASS_TILE_SCENE.instantiate()
	var was_placed: bool = await add_tile_to_map_or_rotate_it(t, pos)
	if (was_placed):
		return true
	t = WATER_TILE_SCENE.instantiate()
	was_placed = await add_tile_to_map_or_rotate_it(t, pos)
	if (was_placed):
		return true
	
	# If no other possible tile is avaiable, put water
	placed.append(t)
	await add_on_map(t)
	
	return false


func _fill_world_perlin_noise_heights(height_multiplier: float) -> void:
	setup_noise()
	for col in world_size:
		for row in world_size:
			var tile: BaseTile = get_perlin_tile(row, col)
			var height: float = get_perlin_height(Vector2i(row, col)) * height_multiplier
			set_tile_pos_3d(tile, Vector2i(row, col), height)
			placed.append(tile)
			await add_on_map(tile)


func _fill_world_perlin_noise_positive_heights(height_multiplier: float) -> void:
	setup_noise()
	for col in world_size:
		for row in world_size:
			var tile: BaseTile = get_perlin_tile(row, col)
			var height: float = get_perlin_height(Vector2i(row, col)) * height_multiplier
			if (height < 0):
				height = 0
			set_tile_pos_3d(tile, Vector2i(row, col), height)
			placed.append(tile)
			await add_on_map(tile)


func _try_to_place_coast_in_world() -> void:
	for col in world_size:
		for row in world_size:
			if (_does_list_have_pos(placed, Vector2i(row, col)) == null):
				_try_to_place_coast(Vector2i(row, col))


func _fill_world_perlin_noise_ruled() -> void:
	setup_noise()
	for col in world_size:
		for row in world_size:
			var tile: BaseTile = get_perlin_tile(row, col)
			# Checking if we can place the water tile next to the grass tile
			set_tile_pos(tile, Vector2i(row, col))
			if (can_tile_be_placed(placed, tile)):
				placed.append(tile)
				await add_on_map(tile)
	print_total_palced()
	_try_to_place_coast_in_world()
	print_total_palced()


func generation(gen_mode: GenerationMode) -> void:
	generation_mode = gen_mode
	
	if (gen_mode == GenerationMode.PERLIN):
		_fill_world_perlin_noise() # Best
	elif (gen_mode == GenerationMode.PERLIN_RULED):
		_fill_world_perlin_noise_ruled()
	elif (gen_mode == GenerationMode.PERLIN_ALL_HEIGHTS):
		_fill_world_perlin_noise_heights(2.5)
	elif (gen_mode == GenerationMode.PERLIN_GRASS_HEIGHTS):
		_fill_world_perlin_noise_positive_heights(5)
	elif (gen_mode == GenerationMode.ERROR):
		assert(false, "GenerationMode.ERROR")
	elif (gen_mode != GenerationMode.PERLIN):
		_fill_world_not_perlin_noise()


func _ready():
	super._ready()
	generation(GenerationMode.PERLIN_GRASS_HEIGHTS)
