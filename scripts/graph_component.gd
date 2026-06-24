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

func add_float_property(id: StringName, default := 0.0) -> void:
	var spin_box := SpinBox.new()
	spin_box.name = id

	spin_box.value = default
	spin_box.min_value = -10000.0
	spin_box.max_value = 10000.0
	spin_box.step = 0.01
	spin_box.allow_greater = true
	spin_box.allow_lesser = true

	add_child(spin_box)

func add_vector2_property(id: StringName, default := Vector2(0.0, 0.0)) -> void:
	var container := VBoxContainer.new()
	container.name = id

	#region X Container
	var x_container = HBoxContainer.new()

	var x_label := Label.new()
	x_label.text = 'X'
	x_label.label_settings = LabelSettings.new()
	x_label.label_settings.font_color = Color.RED

	x_container.add_child(x_label)

	var x_spin_box = SpinBox.new()
	x_spin_box.value = default.x
	x_spin_box.min_value = -10000.0
	x_spin_box.max_value = 10000.0
	x_spin_box.step = 0.01
	x_spin_box.allow_greater = true
	x_spin_box.allow_lesser = true

	x_container.add_child(x_spin_box)

	container.add_child(x_container)
	#endregion

	#region Y Container
	var y_container = HBoxContainer.new()

	var y_label := Label.new()
	y_label.text = 'Y'
	y_label.label_settings = LabelSettings.new()
	y_label.label_settings.font_color = Color.GREEN

	y_container.add_child(y_label)

	var y_spin_box = SpinBox.new()
	y_spin_box.value = default.y
	y_spin_box.min_value = -10000.0
	y_spin_box.max_value = 10000.0
	y_spin_box.step = 0.01
	y_spin_box.allow_greater = true
	y_spin_box.allow_lesser = true

	y_container.add_child(y_spin_box)

	container.add_child(y_container)
	#endregion

	add_child(container)
