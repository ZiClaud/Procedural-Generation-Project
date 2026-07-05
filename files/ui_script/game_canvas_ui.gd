extends CanvasLayer

const HINT_KEY: String = "hint"
@onready var hint_label: Label = %HintLabel
@onready var fps_label: Label = %FPSLabel
@onready var facing_label: Label = %FacingLabel
@onready var pos_label: Label = %PosLabel

func toggle_hint():
	hint_label.visible = !hint_label.visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(HINT_KEY):
		toggle_hint()

func _process(delta: float) -> void:
	fps_label.text = "FPS: %d" % int(Engine.get_frames_per_second())
	facing_label.text = "Facing: %s" % Global.facing_direction
	pos_label.text = "Pos: (%.2f, %.2f)" % [get_parent().position.x, get_parent().position.z]
