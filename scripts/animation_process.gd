class_name AnimationProcess


var uid: StringName

var layers := {}
var paths: Dictionary[StringName, ComponentPath] = {}

var canvas_reference: Node


func _init(uid: StringName) -> void:
	self.uid = uid

func update(delta: float) -> void:
	for path_uid in paths:
		var path := paths[path_uid]
		var callable = AnimationEngine.component_catagories[path.component_data.catagory].component_bindings.get(path.component_data.type)
		callable.call(path)


func clear_data() -> void:
	layers = {}

func set_layer_data(layer_uid: StringName, components := {}, connections := []) -> void:
	layers[layer_uid] = {
		'components': components,
		'connections': connections
	}

func get_layer_data(layer_uid: StringName) -> Dictionary:
	return layers[layer_uid]


func stop() -> void:
	paths.clear()


func spawn_path(layer_uid: StringName, layer_data: Dictionary, component_uid: StringName, component_data: Dictionary) -> void:
	var path := ComponentPath.new()
	path.layer_reference = canvas_reference.get_layer(layer_uid)
	path.layer_data_reference = layer_data
	path.paths_reference = paths
	path.component_uid = component_uid
	path.component_data = component_data

	var path_uid := str(randi())
	path.path_uid = path_uid
	paths[path_uid] = path

func spawn_all_of_type(catagory: StringName, type: StringName) -> void:
	for layer_uid in layers:
		var layer_data = layers[layer_uid]
		for component_uid in layer_data.components:
			var component_data = layer_data.components[component_uid]

			if component_data.catagory != catagory: continue
			if component_data.type != type: continue

			spawn_path(layer_uid, layer_data, component_uid, component_data)
