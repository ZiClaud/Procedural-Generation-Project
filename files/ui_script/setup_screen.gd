extends Control

const PROCEDURAL_SCENE = preload("res://scenes/procedural_gen_world.tscn")

@onready var freq_label: Label = %FreqLabel

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(PROCEDURAL_SCENE)


func _ready() -> void:
	var freq: float = 1.0 / Global.world_size
	freq_label.text = String.num_scientific(freq)
