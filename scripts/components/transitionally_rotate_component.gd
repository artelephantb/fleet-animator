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

static func run(component_uid: String, sprite: Node, inputs: Dictionary, variables: Dictionary) -> bool:
	if 'start_rotation' not in variables:
		variables.start_rotation = sprite.rotation

	if 'time_left' not in variables:
		variables.time_left = inputs.time - 2
		variables.frames = 1

	var percent_complete: float = (inputs.time - variables.time_left) / inputs.time

	sprite.rotation = lerp(variables.start_rotation, inputs.rotation, inputs.curve.sample(percent_complete))
	variables.time_left -= 1

	variables.frames += 1

	if variables.time_left <= -1:
		return true

	return false
