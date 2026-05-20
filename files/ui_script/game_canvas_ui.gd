extends CanvasLayer

const HINT_KEY: String = "hint"
@onready var hint_label: Label = %HintLabel


func toggle_hint():
	hint_label.visible = !hint_label.visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(HINT_KEY):
		toggle_hint()
