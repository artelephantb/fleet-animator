extends GraphNode


static var component_name := 'Move to Position'
static var component_description := 'Moves the sprite to a location over the span of multiple frames.'

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

static func run(component_uid: String, sprite: Node, inputs: Dictionary, variables: Dictionary) -> bool:
	if 'start_position' not in variables:
		variables.start_position = sprite.position

	if 'time_left' not in variables:
		variables.time_left = inputs.time - 2
		variables.frames = 1

	var percent_complete: float = (inputs.time - variables.time_left) / inputs.time

	sprite.position = lerp(variables.start_position, inputs.position, inputs.curve.sample(percent_complete))
	variables.time_left -= 1

	variables.frames += 1

	if variables.time_left <= -1:
		return true

	return false
