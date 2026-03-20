extends GraphNode


static var component_name := 'Set Rotation'
static var component_description := 'Sets the rotation of the sprite.'

@onready var rotation_spin_box_reference := $'RotationContainer/SpinBox'


func load_inputs(inputs: Dictionary) -> void:
	if 'rotation' in inputs:
		rotation_spin_box_reference.value = inputs.rotation

func get_inputs() -> Dictionary:
	return {
		'rotation': rotation_spin_box_reference.value
	}

static func run(component_uid: String, sprite: Node, inputs: Dictionary, active_variables: Dictionary) -> bool:
	sprite.rotation = inputs.rotation
	return true
