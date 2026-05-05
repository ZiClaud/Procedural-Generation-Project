class_name DecorationTile
extends BaseTile

@onready var decoration: Decoration = %Decorations


func _ready() -> void:
	decoration.show_decorations()
	# self.add_child(decoration)
