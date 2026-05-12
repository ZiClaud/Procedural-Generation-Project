class_name BaseTile
extends Node3D

# @export var terrain_mesh: Array[PackedScene]
@export var tile_edges_ids: Array[int] = [-1, -1, -1, -1, -1, -1]
@export var _debug_mode: bool = false

var matrix_pos: Vector2i
# my_rotation = 0-5, 0 remains the same, 1 rotates all tile_edges_ids by one step, etc
var _my_rotation: int = 0

var _placed_labels: Array[Label3D] = []


func _create_3d_label() -> Label3D:
	var label: Label3D = Label3D.new()
	label.position.y = 0.1
	
	label.rotation.x = deg_to_rad(-90)
	label.rotation.y = deg_to_rad(-90) + _my_rotation * deg_to_rad(60)
	return label


func _place_id_on_label(label: Label3D, i: int) -> Label3D:
	assert(i >= 0 && i <= 5)
	match (6 + i - _my_rotation) % 6:
		0:
			label.position.x = 0.75
		1:
			label.position.x = 0.5
			label.position.z = 0.5
		2:
			label.position.x = -0.5
			label.position.z = 0.5
		3:
			label.position.x = -0.75
		4:
			label.position.x = -0.5
			label.position.z = -0.5
		5:
			label.position.x = 0.5
			label.position.z = -0.5
	
	return label


func _add_ui():
	var i: int = 0
	for id in tile_edges_ids:
		var label: Label3D = _create_3d_label()
		label.text = String.num_int64(id)
		_place_id_on_label(label, i)
		i += 1
		self.add_child(label)
		_placed_labels.append(label)


func _toggle_ui_visibility():
	for label in _placed_labels:
		label.visible = !label.visible


func _remove_ui():
	for label in _placed_labels:
		label.queue_free()
	_placed_labels = []


func _rotate():
	self.rotation.y = _my_rotation * deg_to_rad(-60)


func _increase_tile_edges_ids():
	var new_tile_edges_ids: Array[int] = []
	#new_tile_edges_ids.append(tile_edges_ids[tile_edges_ids.size() - 1]) # = 5
	new_tile_edges_ids.append(tile_edges_ids[5])
	#for i in tile_edges_ids.size() - 2: # = 4
	for i in 5:
		new_tile_edges_ids.append(tile_edges_ids[i])
	
	tile_edges_ids = new_tile_edges_ids


func increase_my_rotation():
	_my_rotation += 1
	assert(_my_rotation >= 0 && _my_rotation <= 5)
	_rotate()
	
	_increase_tile_edges_ids()


func toggle_debug_mode():
	_debug_mode = !_debug_mode
	
	if(_debug_mode):
		_add_ui()
	else:
	
		_remove_ui()


func _ready() -> void:
	assert(tile_edges_ids.size() == 6)
	assert(_my_rotation >= 0 && _my_rotation <= 5)
	_rotate()
	if(_debug_mode):
		_add_ui()


func print() -> void:
	print(self)
	print("Tile Edges IDs", tile_edges_ids)
	print("Matrix Pos:", matrix_pos)


#func log() -> String:
	#var log: String = ""
	#print(self)
	#print(["Tile Edges IDs", tile_edges_ids])
	#print(["Matrix Pos:", matrix_pos])
	#return log
