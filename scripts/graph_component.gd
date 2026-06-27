class_name GraphComponent
extends GraphNode


var catagory: StringName
var type: StringName


func _init(catagory: StringName, type: StringName) -> void:
	self.catagory = catagory
	self.type = type

	AnimationEngine.component_catagories[catagory].component_looks[type].call(self)


func set_inputs(inputs: Dictionary) -> void:
	for child in get_children():
		if (
			child is NumberProperty
			or child is Vector2Property
		):
			child.value = inputs.get(child.name, child.default)
		elif child is CurveEditorProperty:
			child.set_curve(inputs.get(child.name, child.default))
		else:
			var callable = child.get('set_value')
			if callable:
				inputs[child.name] = callable.call(inputs.get(child.name, child.default))

func get_inputs() -> Dictionary:
	var inputs := {}

	for child in get_children():
		if (
			child is NumberProperty
			or child is Vector2Property
		):
			inputs[child.name] = child.value
		elif child is CurveEditorProperty:
			inputs[child.name] = child.get_curve()
		else:
			var callable = child.get('get_value')
			if callable:
				inputs[child.name] = callable.call()

	return inputs


func add_label(text: String) -> void:
	var label := Label.new()
	label.text = text
	add_child(label)

func add_runtime_connection(has_left := true, has_right := true) -> void:
	var label := Label.new()
	label.text = 'Runtime'
	add_child(label)
	set_slot(get_child_count() - 1, has_left, 0, Color.GREEN, has_right, 0, Color.GREEN)

func add_float_property(id: StringName, default := 0.0, min := -10000.0, max := 10000.0, allow_lesser := true, allow_greater := true) -> void:
	var property := NumberProperty.new()
	property.name = id

	property.default = default
	property.min_value = min
	property.max_value = max
	property.allow_lesser = allow_lesser
	property.allow_greater = allow_greater

	add_child(property)
	set_slot(get_child_count() - 1, true, 3, Color.BLUE, false, 0, Color.BLACK)

func add_vector2_property(id: StringName, default := Vector2(0.0, 0.0)) -> void:
	var property := Vector2Property.new()

	property.name = id
	property.default = default

	add_child(property)
	set_slot(get_child_count() - 1, true, 5, Color.PURPLE, false, 0, Color.BLACK)

func add_curve_editor_property(id: StringName) -> void:
	var property := CurveEditorProperty.new()
	property.name = id
	add_child(property)
