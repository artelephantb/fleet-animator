extends Control


@onready var projects_list_reference := $'PanelContainer/VBoxContainer/VBoxContainer/ProjectsList'

var project_list: Array[String] = []


func _ready() -> void:
	var parent := get_parent()
	if parent is Window:
		parent.title = ProjectSettings.get_setting('application/config/name') + ' - Project Manager'

	var config := ConfigFile.new()
	config.load('user://projects.cfg')

	for project_name in config.get_section_keys('projects'):
		project_list.append(config.get_value('projects', project_name))
		projects_list_reference.add_item(project_name)

func _on_new_button_pressed() -> void:
	ProjectLoader.create_new_project_new_window()

func _on_projects_list_item_activated(index: int) -> void:
	ProjectLoader.load_project_new_window(project_list[index])
