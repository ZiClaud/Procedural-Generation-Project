class_name DebugTile
extends BaseTile

@export var txt: String = ""

@onready var label: Label3D = %Label3D


func _add_ui_info():
	var text = "".join(["x = ", String.num_int64(self.matrix_pos.x), "\nz = ", String.num_int64(self.matrix_pos.y), "\n", txt])
	label.text = text


func _ready() -> void:
	_add_ui_info()
	self.debug_mode = true
	_add_ui()
