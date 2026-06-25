extends Node

signal signal_emitted


var processes: Array[AnimationProcess] = []
var component_catagories := {}


func _process(delta: float) -> void:
	for process in processes:
		for path in process.paths:
			print(path)

func register_animation_process() -> AnimationProcess:
	var process := AnimationProcess.new(len(processes))
	processes.append(process)
	return process

func unregister_animation_process(process: AnimationProcess) -> void:
	processes.remove_at(process.index)


func register_catagory_script(path: String) -> void:
	var loaded_script = load(path)
	component_catagories[loaded_script.id] = loaded_script.new()
