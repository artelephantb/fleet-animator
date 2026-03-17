extends GraphNode


@onready var rotation_spin_box_reference := $'RotationContainer/SpinBox'


func load_inputs(inputs: Dictionary) -> void:
	if 'rotation' in inputs:
		rotation_spin_box_reference.value = inputs.rotation

func get_inputs() -> Dictionary:
	return {
		'rotation': rotation_spin_box_reference.value
	}
