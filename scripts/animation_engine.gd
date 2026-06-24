extends Node


signal signal_emitted


var component_catagories := {}


func register_catagory_script(path: String) -> void:
	var loaded_script = load(path)
	component_catagories[loaded_script.id] = loaded_script.new()
