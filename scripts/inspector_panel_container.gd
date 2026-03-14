extends PanelContainer


@onready var v_box_container_reference := $'MarginContainer/VBoxContainer'


func _process(delta: float) -> void:
	pass


func add_property(name: String, value: Variant, flags := []) -> void:
	var property_type := type_string(typeof(value))

	var h_box_container := HBoxContainer.new()
	h_box_container.name = name
	h_box_container.set_meta('type', property_type)

	var label := Label.new()
	label.text = name.capitalize()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	h_box_container.add_child(label)

	var editable

	match property_type:
		'bool':
			editable = PanelContainer.new()
			if 'is_switch' in flags:
				var check_button = CheckButton.new()
				check_button.button_pressed = value
				check_button.text = 'Switch'

				check_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER

				editable.add_child(check_button)

			else:
				var check_box = CheckBox.new()
				check_box.button_pressed = value
				check_box.text = 'On'

				check_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER

				editable.add_child(check_box)
		'int':
			editable = SpinBox.new()
			editable.value = value
		'String':
			editable = LineEdit.new()
			editable.text = value
		_:
			push_error('Invalid property type: ', property_type)
			editable = Label.new()
			editable.text = '[INVALID TYPE]'

	editable.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h_box_container.add_child(editable)

	v_box_container_reference.add_child(h_box_container)


func set_property_value(name: String, value: Variant) -> void:
	var property_reference := get_node(name)

	match property_reference.get_meta('type'):
		'bool':
			property_reference.button_pressed = value
		'int':
			property_reference.value = value
		'String':
			property_reference.text = value


func remove_property(name: String) -> void:
	get_node(name).queue_free()

func remove_all_properties() -> void:
	for child in v_box_container_reference.get_children():
		child.queue_free()
