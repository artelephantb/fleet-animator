class_name AnimationProcess


var uid: StringName

var layers := {}
var paths: Array[ComponentPath] = []


func _init(uid: StringName) -> void:
	self.uid = uid

func update(delta: float) -> void:
	for path in paths:
		var binding = AnimationEngine.component_catagories[path.current_component_data.catagory].component_bindings.get(path.current_component_data.type)
		binding.call(path)


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


func spawn_path(layer_uid: StringName, component_uid: StringName, component_data: Dictionary) -> void:
	var path := ComponentPath.new()
	path.layer_uid = layer_uid
	path.current_component_uid = component_uid
	path.current_component_data = component_data
	paths.append(path)

func spawn_all_of_type(catagory: StringName, type: StringName) -> void:
	for layer_uid in layers:
		var layer_data = layers[layer_uid]
		for component_uid in layer_data.components:
			var component_data = layer_data.components[component_uid]

			if component_data.catagory != catagory: continue
			if component_data.type != type: continue

			spawn_path(layer_uid, component_uid, component_data)
