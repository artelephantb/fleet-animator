class_name GraphComponent
extends GraphNode


var catagory: StringName
var type: StringName


func _init(catagory: StringName, type: StringName) -> void:
	self.catagory = catagory
	self.type = type

	AnimationEngine.component_catagories[catagory].component_looks[type].call(self)


func set_inputs(inputs: Dictionary) -> void:
	pass

func get_inputs() -> Dictionary:
	return {}


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
	var spin_box := SpinBox.new()
	spin_box.name = id

	spin_box.value = default
	spin_box.min_value = min
	spin_box.max_value = max
	spin_box.step = 0.01
	spin_box.allow_lesser = allow_lesser
	spin_box.allow_greater = allow_greater

	add_child(spin_box)
	set_slot(get_child_count() - 1, true, 3, Color.BLUE, false, 0, Color.BLACK)

func add_vector2_property(id: StringName, default := Vector2(0.0, 0.0)) -> void:
	var property := Vector2Property.new()
	property.name = id
	add_child(property)
