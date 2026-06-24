class_name MeshPool
extends MeshTile

@export var scene: PackedScene
var object_pool: Array[MeshTile] = []
var pool_index: int = 0
@export var POOL_INSTANCES: int = 256

func add_to_pool(object: MeshTile) -> void:
	object_pool.append(object)
	#object.set_process(false)
	#object.set_physics_process(false)
	object.hide()


func pull_from_pool() -> MeshTile:
	var object: MeshTile
	if pool_index >= object_pool.size():
		object = scene.instantiate()
		object_pool.append(object)
	else:
		object = object_pool[pool_index]
	
	pool_index += 1
	#object.set_process(true)
	#object.set_physics_process(true)
	object.show()
	return object

func reset_pool() -> void:
	pool_index = 0
	for obj in object_pool:
		obj.hide()
