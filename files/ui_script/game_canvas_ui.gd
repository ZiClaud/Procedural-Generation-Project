extends CanvasLayer

const HINT_KEY: String = "hint"
@onready var hint_label: Label = %HintLabel


func toggle_hint():
	hint_label.visible = !hint_label.visible


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed(HINT_KEY)):
		toggle_hint()
