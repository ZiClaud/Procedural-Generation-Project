class_name MeshTile
extends BaseTile

enum types {
	WATER,
	GRASS,
	SNOW,
	SAND,
}

@onready var mesh_instances: Array[MeshInstance3D] = [
	%MeshInstance3D,
	%MeshInstance3D2,
	%MeshInstance3D3,
]

func _set_mesh_colour(color: Color):
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	
	for mesh_instance in mesh_instances:
		mesh_instance.material_override = material


#region Public functions
func color_self_type(type: types):
	if (type == types.WATER):
		_set_mesh_colour(Color("#89dceb"))
	elif (type == types.GRASS):
		_set_mesh_colour(Color("#a6e3a1"))
	elif (type == types.SNOW):
		_set_mesh_colour(Color("#cdd6f4"))
	elif (type == types.SAND):
		_set_mesh_colour(Color("#f9e2af"))
	else:
		assert(false, "Not colour type fround")

func color_self_height(height: float):
	if (height <= 0):
		color_self_type(types.WATER)
	elif (height < 0.5):
		color_self_type(types.SAND)
	elif (height < 7.5):
		color_self_type(types.GRASS)
	else:
		color_self_type(types.SNOW)
#endregion


func _ready() -> void:
	color_self_height(self.position.y)
