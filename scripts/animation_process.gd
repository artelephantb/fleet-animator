class_name AnimationProcess


var index: int

var animation_data := {}
var paths: Array[ComponentPath] = []


func _init(index: int) -> void:
	self.index = index


func clear_data() -> void:
	animation_data = {}

func set_layer_data(layer_uid: StringName, components := {}, connections := []) -> void:
	animation_data[layer_uid] = {
		'components': components,
		'connections': connections
	}

func get_layer_data(layer_uid: StringName) -> Dictionary:
	return animation_data[layer_uid]


func stop() -> void:
	paths.clear()


func spawn_path(layer_uid: StringName, component_uid: StringName) -> void:
	var path := ComponentPath.new()
	path.layer_uid = layer_uid
	path.current_component_uid = component_uid
	paths.append(path)

func spawn_all_of_type(catagory: StringName, type: StringName) -> void:
	for layer_uid in animation_data:
		var layer_data = animation_data[layer_uid]
		for component_uid in layer_data.components:
			var component_data = layer_data.components[component_uid]

			if component_data.catagory != catagory: continue
			if component_data.type != type: continue

			spawn_path(layer_uid, component_uid)
