@abstract class_name Chunk
extends Placable

@onready var AreaCollisionShape : CollisionShape3D = %CollisionShape3D

func _ready() -> void:
	var shape: BoxShape3D = BoxShape3D.new()
	shape.size = Vector3(Constants.CHUNK_SIZE_X, 256, Constants.CHUNK_SIZE_Z)
	AreaCollisionShape.shape = shape
