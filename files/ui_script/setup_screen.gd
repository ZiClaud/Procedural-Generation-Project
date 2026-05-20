extends Control

const PROCEDURAL_SCENE = preload("res://scenes/procedural_gen_world.tscn")

@onready var world_size_le: LineEdit = %WorldSizeLineEdit
@onready var freq_label: Label = %FreqLabel
@onready var gen_mode_ob: OptionButton = %GenModeOptionButton
@onready var seed_le: LineEdit = %SeedLineEdit
@onready var slow_gen_cb: CheckBox = %SlowGenCheckBox

#region Setup and update UI
func _setup_world_size(ws: int):
	world_size_le.text = String.num_int64(ws)
	Global.world_size = ws
	_update_world_size(ws)

func _update_world_size(num: int):
	if (num > 128):
		num = 128
		world_size_le.text = String.num_int64(num)
	
	Global.world_size = num
	_update_freq_text()
	#_fix_slow_gen_button(num)

func _update_freq_text():
	var freq: float = 1.0 / (Global.world_size / 2.0)
	freq_label.text = String.num_scientific(freq)


func _update_gen_mode(gm: GenerationMode.Mode):
	Global.generation_mode = gm

func _setup_gen_mode(gm: GenerationMode.Mode):
	for gen in GenerationMode.Mode:
		gen_mode_ob.add_item(gen)
	_update_gen_mode(gm)
	gen_mode_ob.select(gm)


func _update_seed(num: int):
	Global.world_seed = num

# DEPRECATED
func _fix_slow_gen_button(num: int):
	if (num > 16): # If it's lower than 16, the player will fall off the map
		slow_gen_cb.disabled = true
		slow_gen_cb.button_pressed = false
		_toggle_slow_gen(slow_gen_cb.button_pressed)
	else:
		slow_gen_cb.disabled = false

func _toggle_slow_gen(is_active: bool):
	Global.is_slow_generation = is_active


func setup_all(ws: int, gm: GenerationMode.Mode):
	_setup_world_size(ws)
	_update_freq_text()
	_setup_gen_mode(gm)
#endregion

#region Buttons
func _on_world_size_line_edit_text_changed(new_text: String) -> void:
	_update_world_size(int(new_text))


func _on_slow_gen_check_box_pressed() -> void:
	_toggle_slow_gen(slow_gen_cb.button_pressed)


func _on_seed_line_edit_text_changed(new_text: String) -> void:
	_update_seed(int(new_text))


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(PROCEDURAL_SCENE)
#endregion


func _ready() -> void:
	setup_all(128, GenerationMode.Mode.PERLIN_POSITIVE_HEIGHTS)
