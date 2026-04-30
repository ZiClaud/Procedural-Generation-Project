class_name BaseTile
extends Node3D

# @export var terrain_mesh: Array[PackedScene]
@export var tile_id: Array[int] = [-1, -1, -1, -1, -1, -1]

func _create_3d_label() -> Label3D:
	var label: Label3D = Label3D.new()
	label.position.y = 0.1
	
	label.rotation.x = 90
	label.rotation.y = 90
	#label.rotation.z = -90
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
	for id in tile_id:
		var label: Label3D = _create_3d_label()
		label.text = String.num_int64(id)
		
		_place_id(label, i)
		i += 1
		self.add_child(label)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(tile_id.size() == 6)
	_add_ui()
