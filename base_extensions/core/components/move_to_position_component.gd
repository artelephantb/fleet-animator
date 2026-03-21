extends GraphNode


static var component_name := 'Move to Position'
static var component_description := 'Moves the sprite to a location over the span of multiple frames.'

var x_spin_box_reference: SpinBox
var y_spin_box_reference: SpinBox

var time_spin_box_reference: SpinBox

var curve_editor_reference: CurveEditor


func _init() -> void:
	title = component_name

	set_slot(0, true, 0, Color.GREEN, true, 0, Color.GREEN)

	#region X Container
	var x_container = HBoxContainer.new()

	var x_label := Label.new()
	x_label.text = 'X'
	x_label.label_settings = LabelSettings.new()
	x_label.label_settings.font_color = Color.RED

	x_container.add_child(x_label)

	x_spin_box_reference = SpinBox.new()
	x_spin_box_reference.min_value = -10000.0
	x_spin_box_reference.max_value = 10000.0
	x_spin_box_reference.step = 0.01
	x_spin_box_reference.allow_greater = true
	x_spin_box_reference.allow_lesser = true

	x_container.add_child(x_spin_box_reference)

	add_child(x_container)
	#endregion

	#region Y Container
	var y_container = HBoxContainer.new()

	var y_label := Label.new()
	y_label.text = 'Y'
	y_label.label_settings = LabelSettings.new()
	y_label.label_settings.font_color = Color.GREEN

	y_container.add_child(y_label)

	y_spin_box_reference = SpinBox.new()
	y_spin_box_reference.min_value = -10000.0
	y_spin_box_reference.max_value = 10000.0
	y_spin_box_reference.step = 0.01
	y_spin_box_reference.allow_greater = true
	y_spin_box_reference.allow_lesser = true

	y_container.add_child(y_spin_box_reference)

	add_child(y_container)
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
	if 'position' in inputs:
		x_spin_box_reference.value = inputs.position.x
		y_spin_box_reference.value = inputs.position.y

	if 'time' in inputs:
		time_spin_box_reference.value = inputs.time

	if 'curve' in inputs:
		curve_editor_reference.set_curve(inputs.curve)

func get_inputs() -> Dictionary:
	return {
		'position': Vector2(x_spin_box_reference.value, y_spin_box_reference.value),
		'time': time_spin_box_reference.value,
		'curve': curve_editor_reference.get_data()
	}

static func run(component_uid: String, sprite: Node, inputs: Dictionary, variables: Dictionary) -> bool:
	if 'start_position' not in variables:
		variables.start_position = sprite.position

	if 'time_left' not in variables:
		variables.time_left = inputs.time - 2
		variables.frames = 1

	var percent_complete: float = (inputs.time - variables.time_left) / inputs.time

	sprite.position = lerp(variables.start_position, inputs.position, inputs.curve.sample(percent_complete))
	variables.time_left -= 1

	variables.frames += 1

	if variables.time_left <= -1:
		return true

	return false
