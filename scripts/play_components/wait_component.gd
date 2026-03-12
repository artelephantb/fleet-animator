extends Node


static func run(component_uid: String, sprite: Node, inputs: Dictionary, variables: Dictionary) -> bool:
	if 'time_left' not in variables:
		variables.time_left = int(inputs.time)
		return false

	variables.time_left -= 1

	if variables.time_left > 0:
		return false

	return true
