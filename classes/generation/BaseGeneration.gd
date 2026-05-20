class_name BaseGeneration
extends MyGeneration

var generation_time: float = 0 # TODO: Change in settings UI
var generation_mode: GenerationMode # TODO: Change in settings UI

var all_tiles_ps: Array[PackedScene] = []

@export var world_size: int = 32 # TODO: Change in settings UI
var world_middle: float = world_size / 2

var placed: Array[BaseTile] = []

@onready var player: CharacterBody3D = %ProtoController

var reset_key: String = "F1"
var debug_key: String = "F3"

#region Debug
func _toggle_debug_mode():
	for tile in placed:
		tile.toggle_debug_mode()

func print_total_palced():
	print("Placed: ", placed.size(), "/", world_size * world_size)

func _add_ui_debug_tile(tile: DebugTile, text: String):
	# TODO assert(tile.is_class("DebugTile"))
	
	tile.txt = "".join([
		"x = ", String.num_int64(tile.position.x),
		", y = ", String.num_int64(tile.position.y),
		", z = ", String.num_int64(tile.position.z),
		"\n", text,
	])
#endregion

#region Terrain generation
func _reset_generation():
	for tile in placed:
		tile.queue_free()
	placed = []
	generation(generation_mode)
#endregion

#region Terrain population
func add_on_map(tile: BaseTile) -> void:
	if (generation_time > 0):
		await get_tree().create_timer(generation_time).timeout
	self.add_child(tile)

func set_tile_pos(tile: BaseTile, pos: Vector2i) -> BaseTile:
	tile.matrix_pos = pos
	
	var row: int = pos.x
	var col: int = pos.y
	
	if (row % 2):
		tile.position.x = col * 2
		tile.position.z = row * 1.75
	else:
		tile.position.x = col * 2 + 1
		tile.position.z = row * 1.75
	return tile

func set_tile_pos_3d(tile: BaseTile, pos: Vector2i, height: float) -> BaseTile:
	tile.matrix_pos = pos
	
	var row: int = pos.x
	var col: int = pos.y
	
	if (row % 2):
		tile.position.x = col * 2
		tile.position.z = row * 1.75
	else:
		tile.position.x = col * 2 + 1
		tile.position.z = row * 1.75
	tile.position.y = height
	return tile

func add_tile_to_map_or_rotate_it(tile: BaseTile, pos: Vector2i) -> bool:
	for curr_rotation in 5: # 1 for each hexagon side
		set_tile_pos(tile, pos)
		if (can_tile_be_placed(placed, tile)):
			placed.append(tile)
			await add_on_map(tile)
			return true
		tile.increase_my_rotation()
	return false
#endregion

#region Player
func place_player():
	player.position.x = world_middle * 2
	player.position.z = world_middle * 1.75
	#player.position.y = world_size
#endregion

#region Utils
### Returns the tile if it was found, null otherwise
func _does_list_have_pos(tiles: Array[BaseTile], pos: Vector2i) -> BaseTile:
	for tile in tiles:
		if(tile.matrix_pos == pos):
			return tile
	return null

func can_tile_be_placed(placed_tiles: Array[BaseTile], tile: BaseTile) -> bool:
	var tile5: BaseTile
	var tile0: BaseTile
	var tile1: BaseTile
	var tile2: BaseTile
	var tile3: BaseTile
	var tile4: BaseTile
	
	if (tile.matrix_pos.x % 2):
		tile5 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(-1, 0))
		tile0 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(0, 1))
		tile1 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(1, 0))
		tile2 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(1, -1))
		tile3 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(0, -1))
		tile4 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(-1, -1))
	else:
		tile5 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(-1, 1))
		tile0 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(0, 1))
		tile1 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(1, 1))
		tile2 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(1, 0))
		tile3 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(0, -1))
		tile4 = _does_list_have_pos(placed_tiles, tile.matrix_pos + Vector2i(-1, 0))
	
	if (tile0 != null && tile.tile_edges_ids[0] != tile0.tile_edges_ids[3]):
		return false
	if (tile1 != null && tile.tile_edges_ids[1] != tile1.tile_edges_ids[4]):
		return false
	if (tile2 != null && tile.tile_edges_ids[2] != tile2.tile_edges_ids[5]):
		return false
	if (tile3 != null && tile.tile_edges_ids[3] != tile3.tile_edges_ids[0]):
		return false
	if (tile4 != null && tile.tile_edges_ids[4] != tile4.tile_edges_ids[1]):
		return false
	if (tile5 != null && tile.tile_edges_ids[5] != tile5.tile_edges_ids[2]):
		return false
	
	return true

func get_random_tile() -> BaseTile:
	var rand_id = randi() % all_tiles_ps.size()
	return all_tiles_ps[rand_id].instantiate()
#endregion

#region Partial classes
func generation(_gen_mode: GenerationMode) -> void:
	assert(false, "Function 'generation' not implemented")
#endregion


func _fill_all_tiles_ps():
	all_tiles_ps.append_array([GRASS_TILE_SCENE, WATER_TILE_SCENE, DECORATION_TILE_SCENE])
	#all_tiles_ps.append_array(ROADS_TILES_SCENE)
	all_tiles_ps.append_array(COASTS_TILES_SCENE)
	#all_tiles_ps.append_array(RIVERS_TILES_SCENE)
	#all_tiles_ps.append_array(ROADS_RIVERS_TILES_SCENE)


func _ready():
	_fill_all_tiles_ps()
	place_player()


func _process(_delta):
	if(Input.is_action_just_pressed(reset_key)):
		_reset_generation()
	if(Input.is_action_just_pressed(debug_key)):
		_toggle_debug_mode()
