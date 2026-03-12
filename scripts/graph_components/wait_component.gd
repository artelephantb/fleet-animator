extends GraphNode

@onready var spin_box_reference := $'TimeContainer/SpinBox'

func load_inputs(inputs: Dictionary) -> void:
	if 'time' in inputs:
		spin_box_reference.value = inputs.time

func get_inputs() -> Dictionary:
	return {
		'time': spin_box_reference.value
	}
