extends GraphNode


@onready var x_position_spin_box_reference := $'XPositionContainer/SpinBox'
@onready var y_position_spin_box_reference := $'YPositionContainer/SpinBox'


func load_inputs(inputs: Dictionary) -> void:
	if 'scale' in inputs:
		x_position_spin_box_reference.value = inputs.scale.x
		y_position_spin_box_reference.value = inputs.scale.y

func get_inputs() -> Dictionary:
	return {
		'scale': Vector2(x_position_spin_box_reference.value, y_position_spin_box_reference.value)
	}
