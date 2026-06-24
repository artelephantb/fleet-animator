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

	spin_box.value = default
	spin_box.min_value = -10000.0
	spin_box.max_value = 10000.0
	spin_box.step = 0.01
	spin_box.allow_greater = true
	spin_box.allow_lesser = true

	add_child(spin_box)
