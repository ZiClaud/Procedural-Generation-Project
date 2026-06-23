class_name Placable
extends Node3D

const WIDTH = 0
const HEIGHT = 0

#region Base
func print() -> void:
	print(self)
	print("Matrix Pos: REMOVED")

#func log() -> String:
	#var log: String = ""
	#print(self)
	#print(["Tile Edges IDs", tile_edges_ids])
	#print(["Matrix Pos:", matrix_pos])
	#return log
#endregion

func add_on_map(placable: Placable, pos: Vector2i) -> void:
	Global.placed[pos] = placable
	self.add_child.call_deferred(placable)
