class_name Chunk
extends Placable

@onready var ChunkX1 : MeshInstance3D = %XChunkMeshInstance3D
@onready var ChunkX2 : MeshInstance3D = %XChunkMeshInstance3D2
@onready var ChunkZ1 : MeshInstance3D = %ZChunkMeshInstance3D
@onready var ChunkZ2 : MeshInstance3D = %ZChunkMeshInstance3D2
@onready var CollisionShape : CollisionShape3D = %CollisionShape3D

func _ready() -> void:
	# ChunkX1.position = Vector3i(Constants.CHUNK_SIZE_X / 2, Constants.CHUNK_SIZE, 0)
	# ChunkX2.position = Vector3i(-Constants.CHUNK_SIZE_X / 2, Constants.CHUNK_SIZE, 0)
	# ChunkZ1.position = Vector3i(0, Constants.CHUNK_SIZE, Constants.CHUNK_SIZE_Z / 2)
	# ChunkZ2.position = Vector3i(0, Constants.CHUNK_SIZE, -Constants.CHUNK_SIZE_Z / 2)
	
	var shape: BoxShape3D = BoxShape3D.new()
	shape.size = Vector3(Constants.CHUNK_SIZE_X, 256, Constants.CHUNK_SIZE_Z)
	CollisionShape.shape = shape
