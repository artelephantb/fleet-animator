extends Window

signal load_project(project_name: String, project_location: String)


@onready var project_name_line_edit_reference := $'MarginContainer/VBoxContainer/ProjectNameLineEdit'
var project_location: String


func _on_close_requested() -> void:
	hide()

func _on_load_button_pressed() -> void:
	var location: String
	if project_location:
		location = project_location
	else:
		location = 'user://projects/' + project_name_line_edit_reference.text

	load_project.emit(project_name_line_edit_reference.text, location)
	hide()
