extends Node3D

var generation_time: float = 0.1

@export var all_tiles_ps: Array[PackedScene] = []
#@export var tiles_weight: Array[int] = []

@export var world_size: int = 8
var world_middle: int = world_size / 2

var placed: Array[BaseTile] = []

@onready var player: CharacterBody3D = %ProtoController

var reset_key: String = "F1"
var debug_key: String = "F3"

func _reset_generation():
	for tile in placed:
		tile.queue_free()
	placed = []
	_generation_base()

func _toggle_debug_mode():
	for tile in placed:
		tile.toggle_debug_mode()

func _add_on_map(tile: BaseTile) -> void:
	await get_tree().create_timer(generation_time).timeout
	self.add_child(tile)
	#print("Placed: ", placed.size(), "/", world_size * world_size)


func _add_ui_debug_tile(tile: DebugTile, text: String):
	# TODO assert(tile.is_class("DebugTile"))
	
	tile.txt = "".join([
		"x = ", String.num_int64(tile.position.x),
		", y = ", String.num_int64(tile.position.y),
		", z = ", String.num_int64(tile.position.z),
		"\n", text,
	])


func _set_tile_pos(tile: BaseTile, pos: Vector2i) -> BaseTile:
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


func _fill_world_with_debug():
	for col in world_size:
		for row in world_size:
			var tile: DebugTile = all_tiles_ps[0].instantiate()
			
			_set_tile_pos(tile, Vector2i(row, col))
			
			_add_ui_debug_tile(tile, "")
			
			await _add_on_map(tile)


func _fill_world_random():
	var used: Array[Vector2] = []
	var max_tiles: int = world_size * world_size
	for i in max_tiles:
		var rand_pos: Vector2i = Vector2i(randi() % world_size, randi() % world_size)
		if (used.has(rand_pos)):
			continue
		
		var tile: BaseTile = get_random_time()
		_set_tile_pos(tile, rand_pos)
		used.append(rand_pos)
		self.add_child(tile)


### Returns the tile if it was found, null otherwise
func _does_list_have_pos(tiles: Array[BaseTile], pos: Vector2i) -> BaseTile:
	for tile in tiles:
		if(tile.matrix_pos == pos):
			return tile
	return null

func _can_tile_be_placed(tiles: Array[BaseTile], tile: BaseTile) -> bool:
	var tile5: BaseTile
	var tile0: BaseTile
	var tile1: BaseTile
	var tile2: BaseTile
	var tile3: BaseTile
	var tile4: BaseTile
	
	if (tile.matrix_pos.x % 2):
		tile5 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(-1, 0))
		tile0 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(0, 1))
		tile1 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(1, 0))
		tile2 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(1, -1))
		tile3 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(0, -1))
		tile4 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(-1, -1))
	else:
		tile5 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(-1, 1))
		tile0 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(0, 1))
		tile1 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(1, 1))
		tile2 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(1, 0))
		tile3 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(0, -1))
		tile4 = _does_list_have_pos(tiles, tile.matrix_pos + Vector2i(-1, 0))
	
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


func _fill_world_with_rules(n_iterations: int):
	for col in world_size:
		for row in world_size:
			for curr_iteration in n_iterations:
				var tile: BaseTile = get_random_time()
				_set_tile_pos(tile, Vector2i(row,col))
				if (_can_tile_be_placed(placed, tile)):
					placed.append(tile)
					await _add_on_map(tile)
					break


func _fill_world_random_with_rules():
	var num_iterations: int = world_size * world_size
	for i in num_iterations:
		var rand_pos: Vector2i = Vector2i(randi() % world_size, randi() % world_size)
		
		if (_does_list_have_pos(placed, rand_pos) != null):
			continue
		
		var tile: BaseTile = get_random_time()
		_set_tile_pos(tile, rand_pos)
		if (_can_tile_be_placed(placed, tile)):
			# DEBUG TILE tile.txt = String.num_int64(i)
			placed.append(tile)
			await _add_on_map(tile)


func _fill_world_with_rules_and_rotation():
	for col in world_size:
		for row in world_size:
			var tile: BaseTile = get_random_time()
			for curr_rotation in 5: # 1 for each hexagon side
				_set_tile_pos(tile, Vector2i(row,col))
				if (_can_tile_be_placed(placed, tile)):
					placed.append(tile)
					await _add_on_map(tile)
					break
				tile.increase_my_rotation()


func _fill_world_with_rules_and_rotation_2(n_iterations: int):
	var is_placed: bool
	for col in world_size:
		for row in world_size:
			is_placed = false
			for curr_iteration in n_iterations:
				var tile: BaseTile = get_random_time()
				_set_tile_pos(tile, Vector2i(row,col))
				for curr_rotation in 5: # 1 for each hexagon side
					if (_can_tile_be_placed(placed, tile)):
						placed.append(tile)
						await _add_on_map(tile)
						is_placed = true
						break
					tile.increase_my_rotation()
				if(is_placed):
					break


func get_random_time() -> BaseTile:
	var rand_id = randi() % all_tiles_ps.size()
	return all_tiles_ps[rand_id].instantiate()


func _generation_base():
	# _fill_world_with_debug()
	# _fill_world_random()
	#_fill_world_with_rules(10)	# Best
	# _fill_world_random_with_rules()
	#_fill_world_with_rules_and_rotation()
	_fill_world_with_rules_and_rotation_2(10)


func _ready():
	# assert(all_tiles_ps.size() == tiles_weight.size()) # TODO: remove when weights work
	player.position.x = world_middle * 2
	player.position.z = world_middle * 1.75
	player.position.y = world_size
	_generation_base()


func _process(_delta):
	if(Input.is_action_just_pressed(reset_key)):
		_reset_generation()
	if(Input.is_action_just_pressed(debug_key)):
		_toggle_debug_mode()
