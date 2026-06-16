extends Control

@onready var freq_label: Label = %FreqLabel
@onready var freq_le: LineEdit = %FreqLineEdit
@onready var seed_le: LineEdit = %SeedLineEdit
@onready var start_btn: Button = %StartButton

#region Setup and update UI
#func _setup_chunk_size(cs: int):
#	world_size_le.text = String.num_int64(cs)
#	Global.world_size = cs
#	_update_chunk_size(cs)

#func _update_chunk_size(num: int):
#	if (num > 128):
#		num = 128
#		world_size_le.text = String.num_int64(num)
#	
#	Global.world_size = num
#	_update_freq_text()

func _update_seed(num: int):
	Global.WORLD_SEED = num

func _update_freq(num: float):
	Global.FREQ_DIVIDER = num

func _update_freq_text():
	var freq: float = 1.0 / (Global.FREQ_DIVIDER)
	freq_label.text = String.num_scientific(freq)

func _update_freq_line_edit_value():
	freq_le.text = String.num_scientific(Global.FREQ_DIVIDER)

#func setup_all(cs: int):
#	_setup_chunk_size(cs)
func setup_all():
	_update_freq_line_edit_value()
	_update_freq_text()
#endregion

#region Buttons
func _on_seed_line_edit_text_changed(new_text: String) -> void:
	_update_seed(int(new_text))

func _on_freq_line_edit_text_changed(new_text: String) -> void:
	_update_freq(float(new_text))
	_update_freq_text()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(Scenes.PROCEDURAL_SCENE)
#endregion


func _ready() -> void:
	setup_all()
