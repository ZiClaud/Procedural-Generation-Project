class_name BaseTile
extends Node3D

# @export var terrain_mesh: Array[PackedScene]
@export var tile_edges_ids: Array[int] = [-1, -1, -1, -1, -1, -1]
@export var debug_mode: bool = false

var matrix_pos: Vector2i
# my_rotation = 0-5, 0 remains the same, 1 rotates all tile_edges_ids by one step, etc
var my_rotation: int = 0

func _create_3d_label() -> Label3D:
	var label: Label3D = Label3D.new()
	label.position.y = 0.1
	
	label.rotation.x = -90
	label.rotation.y = -90
	return label


func _place_id(label: Label3D, i: int) -> Label3D:
	match i:
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
		
		_place_id(label, i)
		i += 1
		self.add_child(label)


func _rotate(): # TODO Fix
	match my_rotation:
		0:
			self.rotation.y = 0
		1:
			self.rotation.y = 60
		2:
			self.rotation.y = 120
		3:
			self.rotation.y = 180
		4:
			self.rotation.y = 240
		5:
			self.rotation.y = 300


func _ready() -> void:
	assert(tile_edges_ids.size() == 6)
	assert(my_rotation >= 0 && my_rotation <= 5)
	_rotate()
	if(debug_mode):
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
