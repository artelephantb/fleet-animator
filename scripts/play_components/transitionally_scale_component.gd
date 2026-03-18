extends Node


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
