extends GraphNode


@onready var x_position_spin_box_reference := $'XPositionContainer/SpinBox'
@onready var y_position_spin_box_reference := $'YPositionContainer/SpinBox'

@onready var time_spin_box_reference := $'TimeContainer/SpinBox'

@onready var curve_editor_reference := $'CurveEditor'


func load_inputs(inputs: Dictionary) -> void:
	if 'position' in inputs:
		x_position_spin_box_reference.value = inputs.position.x
		y_position_spin_box_reference.value = inputs.position.y

	if 'time' in inputs:
		time_spin_box_reference.value = inputs.time

	if 'curve' in inputs:
		curve_editor_reference.set_curve(inputs.curve)

func get_inputs() -> Dictionary:
	return {
		'position': Vector2(x_position_spin_box_reference.value, y_position_spin_box_reference.value),
		'time': time_spin_box_reference.value,
		'curve': curve_editor_reference.get_data()
	}
