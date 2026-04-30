class_name DebugTile
extends BaseTile

@export var pos_x: int = -1
@export var pos_y: int = -1
@export var pos_z: int = -1
@export var txt: String = ""

@onready var label: Label3D = %Label3D


func _add_ui_info():
	var text = "".join(["x = ", String.num_int64(pos_x), "\ny = ", String.num_int64(pos_y), "\nz = ", String.num_int64(pos_z), "\n", txt])
	label.text = text


func _ready() -> void:
	_add_ui_info()
	# _add_ui()
