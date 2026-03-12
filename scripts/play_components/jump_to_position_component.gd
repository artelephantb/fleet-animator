extends Node


static func run(component_uid: String, sprite: Node, inputs: Dictionary, active_variables: Dictionary) -> bool:
	sprite.position = inputs.position
	return true
