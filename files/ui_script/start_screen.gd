extends Control

const SETUP_SCREEN = preload("res://scenes/ui/setup_screen.tscn")

func _on_pg_button_pressed() -> void:
	get_tree().change_scene_to_packed(SETUP_SCREEN)

func _ready() -> void:
	Engine.set_max_fps(60)
