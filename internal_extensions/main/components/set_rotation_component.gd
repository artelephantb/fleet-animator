extends GraphNode


static var component_name := 'Set Rotation'
static var component_description := 'Sets the rotation of the sprite.'

var rotation_spin_box_reference: SpinBox


func _init() -> void:
	title = component_name

	set_slot(0, true, 0, Color.GREEN, true, 0, Color.GREEN)

	var time_container = HBoxContainer.new()

	var time_label := Label.new()
	time_label.text = 'Rotation'

	time_container.add_child(time_label)

	rotation_spin_box_reference = SpinBox.new()
	rotation_spin_box_reference.min_value = -10000.0
	rotation_spin_box_reference.max_value = 10000.0
	rotation_spin_box_reference.step = 0.01
	rotation_spin_box_reference.allow_greater = true
	rotation_spin_box_reference.allow_lesser = true

	time_container.add_child(rotation_spin_box_reference)

	add_child(time_container)


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
