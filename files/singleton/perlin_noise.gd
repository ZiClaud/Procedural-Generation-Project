extends Node

#region Perlin Noise
var noise: FastNoiseLite

func setup_noise():
	var world_seed: int = randi()
	if (Global.WORLD_SEED > 0):
		world_seed = Global.WORLD_SEED

	print("Seed: ", world_seed)
	
	var freq: float = 1 / Global.FREQ_DIVIDER
	print("Freq: ", freq)

	noise = FastNoiseLite.new()

	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.seed = world_seed
	noise.frequency = freq
#endregion
