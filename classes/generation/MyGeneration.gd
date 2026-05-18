class_name MyGeneration
extends Node3D

const DEBUG_TILE_SCENE: PackedScene = preload("res://tiles/debug_tile.tscn")
const GRASS_TILE_SCENE: PackedScene = preload("res://tiles/grass_tile.tscn")
const WATER_TILE_SCENE: PackedScene = preload("res://tiles/water_tile.tscn")
const DECORATION_TILE_SCENE: PackedScene = preload("res://tiles/decoration_tile.tscn")
const ROADS_TILES_SCENE: Array[PackedScene] = [
	preload("res://tiles/road_a_tile.tscn"), 
	preload("res://tiles/road_b_tile.tscn"), 
	preload("res://tiles/road_c_tile.tscn")
	]
const COASTS_TILES_SCENE: Array[PackedScene] = [
	preload("res://tiles/coast_d_tile.tscn"), 
	preload("res://tiles/coast_c_tile.tscn"), 
	preload("res://tiles/coast_b_tile.tscn"), 
	preload("res://tiles/coast_a_tile.tscn"), 
	preload("res://tiles/coast_e_tile.tscn")
	]
const RIVERS_TILES_SCENE: Array[PackedScene] = [
	preload("res://tiles/river_a_tile.tscn"), 
	preload("res://tiles/river_a2_tile.tscn"), 
	preload("res://tiles/river_b_tile.tscn"), 
	preload("res://tiles/river_c_tile.tscn")
	]
const ROADS_RIVERS_TILES_SCENE: Array[PackedScene] = [
	preload("res://tiles/road_river_a_tile.tscn"), 
	preload("res://tiles/road_river_b_tile.tscn")
	]

enum GenerationMode {
	ERROR,
	DEBUG,
	RANDOM,
	RULED,
	RULED_RANDOM,
	RULED_RANDOM_ROTATION,
	BETTER_RULED_RANDOM_ROTATION,
	PERLIN,
	PERLIN_RULED,
	PERLIN_ALL_HEIGHTS,
	PERLIN_POSITIVE_HEIGHTS,
}
