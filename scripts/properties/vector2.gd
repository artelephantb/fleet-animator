class_name Vector2Property
extends HBoxContainer


@export var value := Vector2(0.0, 0.0):
	set(new):
		value = new
		x_spin_box_reference.value = value.x
		y_spin_box_reference.value = value.y

var x_spin_box_reference := SpinBox.new()
var y_spin_box_reference := SpinBox.new()

var default := Vector2(0.0, 0.0)


func _ready() -> void:
	var name_label := Label.new()
	name_label.text = name.capitalize()
	add_child(name_label)

	var container := VBoxContainer.new()

	#region X Container
	var x_container = HBoxContainer.new()

	var x_label := Label.new()
	x_label.text = 'X'
	x_label.label_settings = LabelSettings.new()
	x_label.label_settings.font_color = Color.RED

	x_container.add_child(x_label)

	x_spin_box_reference.value_changed.connect(x_spin_box_updated)
	x_spin_box_reference.value = value.x
	x_spin_box_reference.min_value = -10000.0
	x_spin_box_reference.max_value = 10000.0
	x_spin_box_reference.step = 0.01
	x_spin_box_reference.allow_greater = true
	x_spin_box_reference.allow_lesser = true

	x_container.add_child(x_spin_box_reference)

	container.add_child(x_container)
	#endregion

	#region Y Container
	var y_container = HBoxContainer.new()

	var y_label := Label.new()
	y_label.text = 'Y'
	y_label.label_settings = LabelSettings.new()
	y_label.label_settings.font_color = Color.GREEN

	y_container.add_child(y_label)

	y_spin_box_reference.value_changed.connect(y_spin_box_updated)
	y_spin_box_reference.value = value.y
	y_spin_box_reference.min_value = -10000.0
	y_spin_box_reference.max_value = 10000.0
	y_spin_box_reference.step = 0.01
	y_spin_box_reference.allow_greater = true
	y_spin_box_reference.allow_lesser = true

	y_container.add_child(y_spin_box_reference)

	container.add_child(y_container)
	#endregion

	add_child(container)


func x_spin_box_updated(new_value) -> void:
	value.x = new_value

func y_spin_box_updated(new_value) -> void:
	value.y = new_value
