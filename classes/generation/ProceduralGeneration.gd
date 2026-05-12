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
		return all_tiles_ps[0].instantiate()
	else:
		return all_tiles_ps[1].instantiate()


func _fill_world_not_using_perlin_noise() -> void:
	for col in world_size:
		for row in world_size:
			var tile: BaseTile = get_random_tile()
			_set_tile_pos(tile, Vector2i(row, col))
			placed.append(tile)
			await _add_on_map(tile)


func _fill_world_using_perlin_noise() -> void:
	setup_noise()
	for col in world_size:
		for row in world_size:
			var tile: BaseTile = get_perlin_tile(row, col)
			_set_tile_pos(tile, Vector2i(row, col))
			placed.append(tile)
			await _add_on_map(tile)


func procedural_generation(gen_mode: GenerationMode) -> void:
	#super.generation(gen_mode)
	#pass
	
	if (gen_mode == GenerationMode.PERLIN):
		_fill_world_using_perlin_noise()
	elif (gen_mode != GenerationMode.PERLIN):
		_fill_world_not_using_perlin_noise()


func _ready():
	super._ready()
	procedural_generation(GenerationMode.PERLIN)
