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
		'Vector2':
			editable = VBoxContainer.new()

			# X Position
			var x_h_box_container := HBoxContainer.new()

			var x_label := Label.new()
			x_label.text = 'X'
			x_label.add_theme_color_override('font_color', Color.RED)
			x_h_box_container.add_child(x_label)

			var x_spin_box := SpinBox.new()

			x_spin_box.min_value = -10000.0
			x_spin_box.max_value = 10000.0

			x_spin_box.allow_greater = true
			x_spin_box.allow_lesser = true

			x_spin_box.value = value.x

			x_spin_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL

			x_h_box_container.add_child(x_spin_box)

			editable.add_child(x_h_box_container)

			# Y Position
			var y_h_box_container := HBoxContainer.new()

			var y_label := Label.new()
			y_label.text = 'Y'
			y_label.add_theme_color_override('font_color', Color.GREEN)
			y_h_box_container.add_child(y_label)

			var y_spin_box := SpinBox.new()

			y_spin_box.min_value = -10000.0
			y_spin_box.max_value = 10000.0

			y_spin_box.allow_greater = true
			y_spin_box.allow_lesser = true

			y_spin_box.value = value.y

			y_spin_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL

			y_h_box_container.add_child(y_spin_box)

			editable.add_child(y_h_box_container)
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
