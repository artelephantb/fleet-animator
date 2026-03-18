extends GraphNode


@onready var x_position_spin_box_reference := $'XPositionContainer/SpinBox'
@onready var y_position_spin_box_reference := $'YPositionContainer/SpinBox'


func load_inputs(inputs: Dictionary) -> void:
	if 'position' in inputs:
		x_position_spin_box_reference.value = inputs.position.x
		y_position_spin_box_reference.value = inputs.position.y

func get_inputs() -> Dictionary:
	return {
		'position': Vector2(x_position_spin_box_reference.value, y_position_spin_box_reference.value)
	}

static func run(component_uid: String, sprite: Node, inputs: Dictionary, active_variables: Dictionary) -> bool:
	sprite.position = inputs.position
	return true
