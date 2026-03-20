extends GraphNode


static var component_name := 'Transitionally Scale'
static var component_description := 'Scales the sprite over multiple frames.'

@onready var x_position_spin_box_reference := $'XPositionContainer/SpinBox'
@onready var y_position_spin_box_reference := $'YPositionContainer/SpinBox'

@onready var time_spin_box_reference := $'TimeContainer/SpinBox'

@onready var curve_editor_reference := $'CurveEditor'


func load_inputs(inputs: Dictionary) -> void:
	if 'scale' in inputs:
		x_position_spin_box_reference.value = inputs.scale.x
		y_position_spin_box_reference.value = inputs.scale.y

	if 'time' in inputs:
		time_spin_box_reference.value = inputs.time

	if 'curve' in inputs:
		curve_editor_reference.set_curve(inputs.curve)

func get_inputs() -> Dictionary:
	return {
		'scale': Vector2(x_position_spin_box_reference.value, y_position_spin_box_reference.value),
		'time': time_spin_box_reference.value,
		'curve': curve_editor_reference.get_data()
	}

static func run(component_uid: String, sprite: Node, inputs: Dictionary, variables: Dictionary) -> bool:
	if 'start_scale' not in variables:
		variables.start_scale = sprite.scale

	if 'time_left' not in variables:
		variables.time_left = inputs.time - 2
		variables.frames = 1

	var percent_complete: float = (inputs.time - variables.time_left) / inputs.time

	sprite.scale = lerp(variables.start_scale, inputs.scale, inputs.curve.sample(percent_complete))
	variables.time_left -= 1

	variables.frames += 1

	if variables.time_left <= -1:
		return true

	return false
