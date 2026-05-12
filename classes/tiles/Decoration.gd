class_name Decoration
extends Node3D

@onready var _decorations: Array[Node3D] = [%hills_A2, %hills_A_trees2, %hills_B2, %hills_B_trees2, %hills_C2, %hills_C_trees2, %hill_single_A2, %hill_single_B2, %hill_single_C2, %mountain_A2, %mountain_A_grass2, %mountain_A_grass_trees2, %mountain_B2, %mountain_B_grass2, %mountain_B_grass_trees2, %mountain_C2, %mountain_C_grass2, %mountain_C_grass_trees2, %rock_single_A2, %rock_single_B2, %rock_single_C2, %rock_single_D2, %rock_single_E2, %trees_A_cut2, %trees_A_large2, %trees_A_medium2, %trees_A_small2, %trees_B_cut2, %trees_B_large2, %trees_B_medium2, %trees_B_small2, %tree_single_A2, %tree_single_A_cut2, %tree_single_B2, %tree_single_B_cut2, %waterlily_A2, %waterlily_B2, %waterplant_A2, %waterplant_B2, %waterplant_C2]

func show_decorations() -> void:
	var dec: Node3D = _decorations.get(randi_range(0, _decorations.size() - 1))
	dec.visible = true
