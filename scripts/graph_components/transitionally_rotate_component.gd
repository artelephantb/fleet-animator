extends GraphNode


@onready var rotation_spin_box_reference := $'RotationContainer/SpinBox'

@onready var time_spin_box_reference := $'TimeContainer/SpinBox'

@onready var curve_editor_reference := $'CurveEditor'


func load_inputs(inputs: Dictionary) -> void:
	if 'rotation' in inputs:
		rotation_spin_box_reference.value = inputs.rotation

	if 'time' in inputs:
		time_spin_box_reference.value = inputs.time

	if 'curve' in inputs:
		curve_editor_reference.set_curve(inputs.curve)

func get_inputs() -> Dictionary:
	return {
		'rotation': rotation_spin_box_reference.value,
		'time': time_spin_box_reference.value,
		'curve': curve_editor_reference.get_data()
	}
