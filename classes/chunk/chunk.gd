extends Node3D

@onready var ChunkX1 : MeshInstance3D = %XChunkMeshInstance3D
@onready var ChunkX2 : MeshInstance3D = %XChunkMeshInstance3D2
@onready var ChunkZ1 : MeshInstance3D = %ZChunkMeshInstance3D
@onready var ChunkZ2 : MeshInstance3D = %ZChunkMeshInstance3D2
@onready var CollisionShape : CollisionShape3D = %CollisionShape3D

func _ready() -> void:
	ChunkX1.position = Vector3i(16 * Constants.TILE_SIZE_X, 16, 0)
	ChunkX2.position = Vector3i(-16 * Constants.TILE_SIZE_X, 16, 0)
	ChunkZ1.position = Vector3i(0, 16, 16 * Constants.TILE_SIZE_Z)
	ChunkZ2.position = Vector3i(0, 16, -16 * Constants.TILE_SIZE_Z)
	
	var BoxShape: BoxShape3D = CollisionShape.shape
	
	BoxShape.size = Vector3i(32 * Constants.TILE_SIZE_X, 256, 32 * Constants.TILE_SIZE_Z)
