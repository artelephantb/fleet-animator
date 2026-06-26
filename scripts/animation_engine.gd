extends Node

signal signal_emitted


var processes: Dictionary[StringName, AnimationProcess] = {}
var component_catagories := {}


func _process(delta: float) -> void:
	for process_uid in processes:
		processes[process_uid].update(delta)

func register_animation_process() -> AnimationProcess:
	var uid := Randomizer.generate_uid()
	var process := AnimationProcess.new(uid)
	processes[uid] = process
	return process

func unregister_animation_process(process: AnimationProcess) -> void:
	processes.erase(process.uid)


func register_catagory_script(path: String) -> void:
	var loaded_script = load(path)
	component_catagories[loaded_script.id] = loaded_script.new()
