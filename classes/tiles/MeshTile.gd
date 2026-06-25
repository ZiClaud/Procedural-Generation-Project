#@icon("res://icon.svg")
class_name MeshTile
extends Placable

@onready var mesh_instances: Array[MeshInstance3D] = [
	%MeshInstance3D,
	%MeshInstance3D2,
	%MeshInstance3D3,
]

func _set_mesh_colour(color: Color, opacity: float = 1.0):
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	if (opacity < 1 && false):
		material.albedo_color.a = opacity
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.blend_mode = BaseMaterial3D.BLEND_MODE_PREMULT_ALPHA
	
	for mesh_instance in mesh_instances:
		mesh_instance.material_override = material


#region Public functions
func color_self_type(type: Global.types):
	if (type == Global.types.WATER):
		_set_mesh_colour(Color("#89dceb"), 0.8)
	elif (type == Global.types.GRASS):
		_set_mesh_colour(Color("#a6e3a1"))
	elif (type == Global.types.SNOW):
		_set_mesh_colour(Color("#cdd6f4"))
	elif (type == Global.types.SAND):
		_set_mesh_colour(Color("#f9e2af"))
	else:
		assert(false, "Not colour type fround")

func color_self_height(height: float):
	if (height <= 0):
		color_self_type(Global.types.WATER)
	elif (height < 0.5):
		color_self_type(Global.types.SAND)
	elif (height < 7.5):
		color_self_type(Global.types.GRASS)
	else:
		color_self_type(Global.types.SNOW)
#endregion

#region LOD Optimization
func _setup_lod() -> void:
	var visibility_range_end: float = max(Constants.CHUNK_SHOWN * Constants.CHUNK_SIZE, 2.5 * Constants.CHUNK_SIZE)
	for mesh_instance in mesh_instances:
		mesh_instance.visibility_range_begin = 0.0
		mesh_instance.visibility_range_end = visibility_range_end
		mesh_instance.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
#endregion


func _ready() -> void:
	color_self_height(self.position.y)
	if (Global.LOD_OPT):
		_setup_lod()
