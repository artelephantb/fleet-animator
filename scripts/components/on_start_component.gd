extends GraphNode


func load_inputs(inputs: Dictionary) -> void:
	pass

func get_inputs() -> Dictionary:
	return {}

static func run(component_uid: String, sprite: Node, inputs: Dictionary, active_variables: Dictionary) -> bool:
	return true
