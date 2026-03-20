extends GraphNode


static var component_name := 'Transitionally Rotate'
static var component_description := 'Rotates the sprite over multiple frames.'

var rotation_spin_box_reference: SpinBox
var time_spin_box_reference: SpinBox
var curve_editor_reference: CurveEditor


func _init() -> void:
	title = component_name

	set_slot(0, true, 0, Color.GREEN, true, 0, Color.GREEN)

	#region Rotation Container
	var rotation_container = HBoxContainer.new()

	var rotation_label := Label.new()
	rotation_label.text = 'Rotation'

	rotation_container.add_child(rotation_label)

	rotation_spin_box_reference = SpinBox.new()
	rotation_spin_box_reference.min_value = -10000.0
	rotation_spin_box_reference.max_value = 10000.0
	rotation_spin_box_reference.step = 0.01
	rotation_spin_box_reference.allow_greater = true
	rotation_spin_box_reference.allow_lesser = true

	rotation_container.add_child(rotation_spin_box_reference)

	add_child(rotation_container)
	#endregion

	#region Time Container
	var time_container = HBoxContainer.new()

	var time_label := Label.new()
	time_label.text = 'Frames'

	time_container.add_child(time_label)

	time_spin_box_reference = SpinBox.new()
	time_spin_box_reference.min_value = -10000.0
	time_spin_box_reference.max_value = 10000.0
	time_spin_box_reference.step = 0.01
	time_spin_box_reference.allow_greater = true
	time_spin_box_reference.allow_lesser = true

	time_container.add_child(time_spin_box_reference)

	add_child(time_container)
	#endregion

	#region Curve Editor
	curve_editor_reference = CurveEditor.new()
	add_child(curve_editor_reference)
	#endregion


func load_inputs(inputs: Dictionary) -> void:
	if 'rotation' in inputs:
		rotation_spin_box_reference.value = inputs.rotation

	if 'time' in inputs:
		time_spin_box_reference.value = inputs.time

	if 'curve' in inputs:
		curve_editor_reference.set_curve(inputs.curve)

func get_inputs() -> Dictionary:
	return {
		'rotation': rotation_spin_box_reference.value,
		'time': time_spin_box_reference.value,
		'curve': curve_editor_reference.get_data()
	}

static func run(component_uid: String, sprite: Node, inputs: Dictionary, variables: Dictionary) -> bool:
	if 'start_rotation' not in variables:
		variables.start_rotation = sprite.rotation

	if 'time_left' not in variables:
		variables.time_left = inputs.time - 2
		variables.frames = 1

	var percent_complete: float = (inputs.time - variables.time_left) / inputs.time

	sprite.rotation = lerp(variables.start_rotation, inputs.rotation, inputs.curve.sample(percent_complete))
	variables.time_left -= 1

	variables.frames += 1

	if variables.time_left <= -1:
		return true

	return false
