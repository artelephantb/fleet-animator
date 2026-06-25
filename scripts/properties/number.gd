class_name NumberProperty
extends HBoxContainer


@export var value := 0.0:
	set(new):
		value = new
		spin_box_reference.value = value

@export var min_value := -10000.0:
	set(new):
		min_value = new
		spin_box_reference.min_value = min_value
@export var max_value := 10000.0:
	set(new):
		max_value = new
		spin_box_reference.max_value = max_value

@export var allow_greater := true:
	set(new):
		allow_greater = new
		spin_box_reference.allow_greater = allow_greater
@export var allow_lesser := true:
	set(new):
		allow_lesser = new
		spin_box_reference.allow_lesser = allow_lesser

@export var step := 0.01:
	set(new):
		step = new
		spin_box_reference.step = step

var spin_box_reference := SpinBox.new()

var default := 0.0


func _ready() -> void:
	var name_label := Label.new()
	name_label.text = name.capitalize()
	add_child(name_label)

	spin_box_reference.value_changed.connect(spin_box_updated)
	spin_box_reference.value = value
	spin_box_reference.min_value = min_value
	spin_box_reference.max_value = max_value
	spin_box_reference.allow_greater = allow_greater
	spin_box_reference.allow_lesser = allow_lesser
	spin_box_reference.step = step

	add_child(spin_box_reference)


func spin_box_updated(new_value) -> void:
	value = new_value
