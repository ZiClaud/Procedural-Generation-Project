extends Node3D

const DEBUG_KEY: String = "F3"

const CHUNK_SIZE : int = 16
const CHUNK_SHOWN: int = 2 	# 1=1, 2=9, 3=16, 4=25, 5=49 (Nice pattern lol)
const FREQ_DIVIDER: float = 32.0 # TODO: Test 128 and 64 too
const HEIGHT_MULTIPLIER : int = 24

var all_tiles_ps: Array[PackedScene] = []
var placed: Array[MeshTile] = []

@onready var player: CharacterBody3D = %ProtoController

#region Utils
### Returns the true if it was found, false otherwise
func _does_list_have_pos(pos: Vector2i) -> bool:
	for tile in placed:
		if(tile.matrix_pos == pos):
			return true
	return false
#endregion

#region Terrain population
const TILE_SIZE_X: float = 2.0
const TILE_SIZE_Z: float = 1.75

func add_on_map(tile: MeshTile) -> void:
	self.add_child(tile)

func set_tile_pos(tile: MeshTile, pos: Vector2i) -> bool:
	tile.matrix_pos = pos
	
	var row: int = pos.x
	var col: int = pos.y
	
	if (row % 2):
		tile.position.x = col * TILE_SIZE_X
		tile.position.z = row * TILE_SIZE_Z
	else:
		tile.position.x = col * TILE_SIZE_X + 1
		tile.position.z = row * TILE_SIZE_Z
	return true

func set_tile_pos_3d(tile: MeshTile, pos: Vector2i, height: float) -> bool:
	tile.matrix_pos = pos
	
	var row: int = pos.x
	var col: int = pos.y
	
	if (row % 2):
		tile.position.x = col * 2
		tile.position.z = row * 1.75
	else:
		tile.position.x = col * 2 + 1
		tile.position.z = row * 1.75
	tile.position.y = height * HEIGHT_MULTIPLIER
	if (height < 0):
		tile.position.y = 0
	return true

# Returns new true if it was created, false otherwise
func set_tile_pos_3d_if_new(tile: MeshTile, pos: Vector2i, height: float) -> bool:
	if _does_list_have_pos(pos) == false:
		return set_tile_pos_3d(tile, pos, height)
	return false
#endregion

#region Chunks
func show_chunk():
	var wx := CHUNK_SIZE * TILE_SIZE_X
	var wz := CHUNK_SIZE * TILE_SIZE_Z
	
	print("TODO")
	pass

func idk():
	# Place an Area2D, when the player is in, it will generate the next area
	pass
#endregion

#region Partial classes
func generation() -> void:
	assert(false, "Function 'generation' not implemented")

#func generate_from_player_position():
#	assert(false, "Function 'generate_from_player_position' not implemented")

func generate_from_player_position():
	var _SIZE : int = CHUNK_SIZE * CHUNK_SHOWN
	for x in range(_SIZE * 2):
		x += (player.position.x / TILE_SIZE_X - _SIZE)
		for z in range(_SIZE * 2):
			z += (player.position.z / TILE_SIZE_Z - _SIZE)
			var pos : Vector2i = Vector2i(z, x)
			add_tile_if_new(pos)
#endregion

#region Perlin Noise
var noise: FastNoiseLite

func setup_noise():
	var world_seed: int = randi()
	if (Global.world_seed > 0):
		world_seed = Global.world_seed

	print("Seed: ", world_seed)
	
	var freq: float = 1 / FREQ_DIVIDER
	print("Freq: ", freq)

	noise = FastNoiseLite.new()

	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.seed = world_seed
	noise.frequency = freq
#endregion

#region Tile
func get_perlin_height(pos: Vector2i) -> float:
	return noise.get_noise_2dv(pos)

func get_tile_colored(pos: Vector2i, height) -> MeshTile:
	var mesh_tile: MeshTile = _get_tile(pos)
	
	mesh_tile.color_self_height(height)
	
	return mesh_tile

func _get_tile(pos: Vector2i) -> MeshTile:
	return Scenes.MESH_TILE_SCENE.instantiate()
#endregion

#region Adding on the map
func add_tile_if_new(pos: Vector2i) -> void:
	if (_does_list_have_pos(pos) == false):
		var height: float = get_perlin_height(pos)
		var tile: MeshTile = get_tile_colored(pos, height)
		#print("Tile added")
		if(set_tile_pos_3d_if_new(tile, pos, height)):
			add_on_map(tile)
		else:
			print("Tile not added 2")
		return
	# TODO: Add print for debug - it should never go here
	print("Tile not added")
#endregion

#region Start
func _process(delta: float) -> void:
	# TODO: Debug
	if(Input.is_action_just_pressed(DEBUG_KEY)):
		generate_from_player_position()

	#generate_from_player_position()
	pass

func _ready() -> void:
	setup_noise()
	generate_from_player_position()
	show_chunk()
#endregion
