class_name DebugTile
extends Node3D

@export var pos_x : int = -1
@export var pos_y : int = -1
@export var pos_z : int = -1
@export var txt : String = ""

@onready var label: Label3D = %Label3D

func _ready() -> void:
	# pos_x.to_string()
	var text = "".join(["x = ", String.num_int64(pos_x), "\ny = ", String.num_int64(pos_y), "\nz = ", String.num_int64(pos_z), "\n", txt])
	label.text = text
