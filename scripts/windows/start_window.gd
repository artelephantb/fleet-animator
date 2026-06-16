extends Control


@onready var projects_list_reference := $'PanelContainer/VBoxContainer/VBoxContainer/ProjectsList'


func _ready() -> void:
	var config := ConfigFile.new()
	config.load('user://projects.cfg')

	for project_name in config.get_section_keys('projects'):
		projects_list_reference.add_item(project_name)

func _on_new_button_pressed() -> void:
	get_tree().change_scene_to_file('res://scenes/main.tscn')
