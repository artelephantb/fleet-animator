extends GraphNode


static var component_name := 'Set Scale'
static var component_description := 'Sets the scale of the sprite.'

var x_spin_box_reference: SpinBox
var y_spin_box_reference: SpinBox


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


func load_inputs(inputs: Dictionary) -> void:
	if 'scale' in inputs:
		x_spin_box_reference.value = inputs.scale.x
		y_spin_box_reference.value = inputs.scale.y

func get_inputs() -> Dictionary:
	return {
		'scale': Vector2(x_spin_box_reference.value, y_spin_box_reference.value)
	}

static func run(component_uid: String, sprite: Node, inputs: Dictionary, active_variables: Dictionary) -> bool:
	sprite.scale = inputs.scale
	return true
