extends GraphNode


static var component_name := 'Jump to Position'
static var component_description := 'Moves the sprite to a location in a single frame.'

var x_spin_box_reference: SpinBox
var y_spin_box_reference: SpinBox


func load_inputs(inputs: Dictionary) -> void:
	if 'position' in inputs:
		x_spin_box_reference.value = inputs.position.x
		y_spin_box_reference.value = inputs.position.y

func get_inputs() -> Dictionary:
	return {
		'position': Vector2(x_spin_box_reference.value, y_spin_box_reference.value)
	}

static func run(component_uid: String, sprite: Node, inputs: Dictionary, active_variables: Dictionary) -> bool:
	sprite.position = inputs.position
	return true
