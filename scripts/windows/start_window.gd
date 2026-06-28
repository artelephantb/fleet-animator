extends Control


@onready var projects_list_reference := $'VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/ProjectsList'
@onready var exit_confirmation_reference := $'ExitConfirmationDialog'

@onready var third_party_popup_reference := $'ThirdPartyCreditsWindow'

var project_list: Array[String] = []


func _ready() -> void:
	get_tree().set_auto_accept_quit(false)

	var parent := get_parent()
	if parent is Window:
		parent.title = ProjectSettings.get_setting('application/config/name') + ' - Project Manager'

	var config := ConfigFile.new()
	config.load('user://projects.cfg')

	var section_keys := config.get_section_keys('projects')
	section_keys.reverse()
	for project_name in section_keys:
		project_list.append(config.get_value('projects', project_name))
		projects_list_reference.add_item(project_name)

	if !OS.has_feature('macos'): $'VBoxContainer/TopBarPanel'.hide()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		exit_confirmation_reference.popup_centered()


func _on_new_button_pressed() -> void:
	ProjectLoader.create_new_project_new_window()

func _on_third_party_button_pressed() -> void:
	third_party_popup_reference.popup_centered()

func _on_third_party_credits_window_close_requested() -> void:
	third_party_popup_reference.hide()


func _on_projects_list_item_activated(index: int) -> void:
	ProjectLoader.load_project_new_window(project_list[index])


func _on_exit_confirmation_dialog_canceled() -> void:
	exit_confirmation_reference.hide()

func _on_exit_confirmation_dialog_confirmed() -> void:
	get_tree().quit()


func _on_top_bar_panel_gui_input(event: InputEvent) -> void:
	DisplayServer.window_start_drag()
