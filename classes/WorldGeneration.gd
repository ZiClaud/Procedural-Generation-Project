extends Node3D

@export var all_tiles_ps: Array[PackedScene] = []
@export var tiles_weight: Array[int] = []

@export var world_size: int = 32
var world_middle: int = world_size / 2

@onready var player: CharacterBody3D = %ProtoController


func _add_ui_debug_tile(tile: DebugTile, row: int, col: int):
	# TODO assert(tile.is_class("DebugTile"))
	tile.pos_x = row
	tile.pos_y = 0
	tile.pos_z = col
	
	tile.txt = "".join([
		"x = ", String.num_int64(tile.position.x),
		", y = ", String.num_int64(tile.position.y),
		", z = ", String.num_int64(tile.position.z),
		# "\nrow = ", String.num_int64(row),
	])


func _set_tile_pos(tile: BaseTile, row: int, col: int) -> BaseTile:
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
			var tile: BaseTile = all_tiles_ps[0].instantiate()
			
			_set_tile_pos(tile, row, col)
			
			_add_ui_debug_tile(tile, row, col)
			
			self.add_child(tile)


func _fill_world_random():
	var used: Array[Vector2] = []
	var max_tiles: int = world_size * world_size
	for i in max_tiles:
		var rand_col = randi() % world_size
		var rand_row = randi() % world_size
		
		if (used.has(Vector2(rand_col, rand_row))):
			continue
		
		var tile: BaseTile = get_random_time()
		_set_tile_pos(tile, rand_col, rand_row)
		used.append(Vector2(rand_col, rand_row))
		self.add_child(tile)


func _generation_base():
	# _fill_world_with_debug()
	_fill_world_random()


func get_random_time() -> BaseTile:
	var rand_id = randi() % all_tiles_ps.size()
	return all_tiles_ps[rand_id].instantiate()


func _ready():
	assert(all_tiles_ps.size() == tiles_weight.size())
	player.position.x = world_middle * 2
	player.position.z = world_middle * 1.75
	_generation_base()
