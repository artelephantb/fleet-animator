extends Node


signal signal_emitted


var component_catagories := {}
var events: Dictionary[StringName, Array] = {}


func register_catagory_script(path: String) -> void:
	var loaded_script = load(path)
	component_catagories[loaded_script.id] = loaded_script.new()


func listen_event(event: StringName, callback: Callable) -> void:
	if event not in events: events[event] = []
	events[event].append(callback)

func emit_event(event: StringName, ...args) -> void:
	for callback in events[event]:
		callback.bindv(args).call()


func start_all_of_type(catagory: StringName, type: StringName) -> void:
	print('Starting: %s %s' % [catagory, type])
