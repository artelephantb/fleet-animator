extends Control


@onready var projects_list_reference := $'PanelContainer/VBoxContainer/VBoxContainer/ProjectsList'
@onready var exit_confirmation_reference := $'ExitConfirmationDialog'

var project_list: Array[String] = []


func _ready() -> void:
	get_tree().set_auto_accept_quit(false)

	var parent := get_parent()
	if parent is Window:
		parent.title = ProjectSettings.get_setting('application/config/name') + ' - Project Manager'

	var config := ConfigFile.new()
	config.load('user://projects.cfg')

	for project_name in config.get_section_keys('projects'):
		project_list.append(config.get_value('projects', project_name))
		projects_list_reference.add_item(project_name)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		exit_confirmation_reference.popup_centered()

func _on_new_button_pressed() -> void:
	ProjectLoader.create_new_project_new_window()

func _on_projects_list_item_activated(index: int) -> void:
	ProjectLoader.load_project_new_window(project_list[index])

func _on_exit_confirmation_dialog_canceled() -> void:
	exit_confirmation_reference.hide()

func _on_exit_confirmation_dialog_confirmed() -> void:
	get_tree().quit()
