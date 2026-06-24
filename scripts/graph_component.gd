class_name GraphComponent
extends GraphNode


var catagory: StringName
var type: StringName


func _init(catagory: StringName, type: StringName) -> void:
	self.catagory = catagory
	self.type = type


func set_inputs(inputs: Dictionary) -> void:
	pass
