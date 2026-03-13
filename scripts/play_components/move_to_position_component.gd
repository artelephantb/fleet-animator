extends Node


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
