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

func get_perlin_tile(row: int, col: int) -> BaseTile:
	var noise_val := noise.get_noise_2d(row, col)
	
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
		if (await add_tile_or_rotate_it(t, pos)):
			return true
	return false


func _try_to_place_coast_in_world() -> void:
	for col in world_size:
		for row in world_size:
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
	_try_to_place_coast_in_world()


func generation(gen_mode: GenerationMode) -> void:
	generation_mode = gen_mode
	
	if (gen_mode == GenerationMode.PERLIN):
		_fill_world_perlin_noise() # Best
	elif (gen_mode == GenerationMode.PERLIN_RULED):
		_fill_world_perlin_noise_ruled()
	elif (gen_mode == GenerationMode.ERROR):
		assert(false, "GenerationMode.ERROR")
	elif (gen_mode != GenerationMode.PERLIN):
		_fill_world_not_perlin_noise()


func _ready():
	super._ready()
	generation(GenerationMode.PERLIN_RULED)
