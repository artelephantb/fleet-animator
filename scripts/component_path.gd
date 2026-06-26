class_name ComponentPath


var layer_reference: Node

var layer_data_reference: Dictionary
var paths_reference: Dictionary

var component_uid: StringName
var component_data: Dictionary

var path_uid: StringName

var variables := {}


func finished_component() -> void:
	paths_reference.erase(path_uid)

	for connection in layer_data_reference.connections:
		if connection.from_node != component_uid: continue

		var path := ComponentPath.new()
		path.layer_reference = layer_reference
		path.layer_data_reference = layer_data_reference
		path.paths_reference = paths_reference
		path.component_uid = connection.to_node
		path.component_data = layer_data_reference.components[path.component_uid]

		var uid := str(randi())
		path.path_uid = uid

		paths_reference[uid] = path
