extends Control


const PROCEDURAL_SCENE = preload("res://scenes/procedural_gen_world.tscn")
const RANDOM_SCENE = preload("res://scenes/random_gen_world.tscn")

const SETUP_SCREEN = preload("res://scenes/ui/setup_screen.tscn")

func _on_pg_button_pressed() -> void:
	#print(Engine.get_license_text())
	#print(Engine.get_license_info())
	#print(Engine.get_copyright_info())
	
	#get_tree().change_scene_to_packed(PROCEDURAL_SCENE)
	get_tree().change_scene_to_packed(SETUP_SCREEN)


func _on_rg_button_pressed() -> void:
	get_tree().change_scene_to_packed(RANDOM_SCENE)
