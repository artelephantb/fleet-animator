extends GraphNode


static var component_name := 'Wait'
static var component_description := 'Waits for a specified amount of frames.'

var spin_box_reference: SpinBox


func _init() -> void:
	title = component_name

	set_slot(0, true, 0, Color.GREEN, true, 0, Color.GREEN)

	var time_container = HBoxContainer.new()

	var time_label := Label.new()
	time_label.text = 'Frames'

	time_container.add_child(time_label)

	spin_box_reference = SpinBox.new()
	spin_box_reference.min_value = -10000.0
	spin_box_reference.max_value = 10000.0
	spin_box_reference.step = 0.01
	spin_box_reference.allow_greater = true
	spin_box_reference.allow_lesser = true

	time_container.add_child(spin_box_reference)

	add_child(time_container)


func load_inputs(inputs: Dictionary) -> void:
	if 'time' in inputs:
		spin_box_reference.value = inputs.time

func get_inputs() -> Dictionary:
	return {
		'time': spin_box_reference.value
	}

static func run(component_uid: String, sprite: Node, inputs: Dictionary, variables: Dictionary) -> bool:
	if 'time_left' not in variables:
		variables.time_left = int(inputs.time)
		return false

	variables.time_left -= 1

	if variables.time_left > 0:
		return false

	return true
