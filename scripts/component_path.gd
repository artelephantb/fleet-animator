class_name ComponentPath


var layer_reference: Node

var layer_data_reference: Dictionary
var paths_reference: Array

var component_uid: StringName
var component_data: Dictionary

var path_index: int

var variables := {}


func set_variable(name: StringName, value) -> void:
	variables[name] = value

func get_variable(name: StringName):
	return variables[name]

func get_or_add_var(name: StringName, default = null):
	return variables.get_or_add(name, default)


func finished_component() -> void:
	paths_reference.remove_at(path_index)

	for connection in layer_data_reference.connections:
		if connection.from_node != component_uid: continue

		var path := ComponentPath.new()
		path.layer_reference = layer_reference
		path.layer_data_reference = layer_data_reference
		path.paths_reference = paths_reference
		path.component_uid = connection.to_node
		path.component_data = layer_data_reference.components[path.component_uid]

		paths_reference.append(path)
