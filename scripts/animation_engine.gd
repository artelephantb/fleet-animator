extends Node


signal signal_emitted


var component_catagories := {}
var events: Dictionary[StringName, Array] = {}

var animation_data := {}

var paths: Array[ComponentPath] = []


func register_catagory_script(path: String) -> void:
	var loaded_script = load(path)
	component_catagories[loaded_script.id] = loaded_script.new()


func listen_event(event: StringName, callback: Callable) -> void:
	if event not in events: events[event] = []
	events[event].append(callback)

func emit_event(event: StringName, ...args) -> void:
	for callback in events[event]:
		callback.bindv(args).call()


func stop_animation() -> void:
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
	print(paths)
