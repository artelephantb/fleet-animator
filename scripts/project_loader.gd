extends Node


func create_new_project() -> void:
	get_tree().change_scene_to_file('res://scenes/main.tscn')

func load_project(path: String) -> void:
	pass
