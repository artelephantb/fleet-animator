extends PanelContainer


@onready var vector2_controls_scene := preload('res://scenes/vector2_controls.tscn')

@onready var v_box_container_reference := $'MarginContainer/VBoxContainer'


func add_property(name: StringName, value: Variant, flags := [], on_value_changed_callable = null) -> void:
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

				if on_value_changed_callable: check_button.connect('toggled', on_value_changed_callable)

				editable.add_child(check_button)

			else:
				var check_box = CheckBox.new()
				check_box.button_pressed = value
				check_box.text = 'On'

				check_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER

				if on_value_changed_callable: check_box.connect('toggled', on_value_changed_callable)

				editable.add_child(check_box)
		'int':
			editable = SpinBox.new()
			editable.value = value
			if on_value_changed_callable: editable.connect('value_changed', on_value_changed_callable)
		'String':
			editable = LineEdit.new()
			editable.text = value
			if on_value_changed_callable: editable.connect('text_changed', on_value_changed_callable)
		'Vector2':
			editable = vector2_controls_scene.instantiate()
			editable.value = value
			if on_value_changed_callable: editable.connect('value_changed', on_value_changed_callable)
		_:
			push_error('Invalid property type: ', property_type)
			editable = Label.new()
			editable.text = '[INVALID TYPE]'

	editable.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h_box_container.add_child(editable)

	v_box_container_reference.add_child(h_box_container)


func set_property_value(name: StringName, value: Variant) -> void:
	var property_reference := v_box_container_reference.get_node(NodePath(name))

	match property_reference.get_meta('type'):
		'bool':
			property_reference.get_child(1).button_pressed = value
		'int':
			property_reference.get_child(1).value = value
		'String':
			property_reference.get_child(1).text = value
		'Vector2':
			property_reference.get_child(1).value = value


func get_property_value(name: StringName) -> Variant:
	var property_reference := v_box_container_reference.get_node(NodePath(name))

	match property_reference.get_meta('type'):
		'bool':
			return property_reference.get_child(1).button_pressed
		'int':
			return property_reference.get_child(1).value
		'String':
			return property_reference.get_child(1).text
		'Vector2':
			return property_reference.get_child(1).value

	return null


func remove_property(name: StringName) -> void:
	v_box_container_reference.get_node(NodePath(name)).queue_free()

func remove_all_properties() -> void:
	for child in v_box_container_reference.get_children():
		child.queue_free()
