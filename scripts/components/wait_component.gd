extends GraphNode


@onready var spin_box_reference := $'TimeContainer/SpinBox'


func load_inputs(inputs: Dictionary) -> void:
	if 'time' in inputs:
		spin_box_reference.value = inputs.time

func get_inputs() -> Dictionary:
	return {
		'time': spin_box_reference.value
	}

static func run(component_uid: String, sprite: Node, inputs: Dictionary, variables: Dictionary) -> bool:
	if 'time_left' not in variables:
		variables.time_left = int(inputs.time)
		return false

	variables.time_left -= 1

	if variables.time_left > 0:
		return false

	return true
