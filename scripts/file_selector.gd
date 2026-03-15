@tool
extends Control


@onready var file_dialog_reference := $'FileDialog'
@onready var line_edit_reference := $'LineEdit'

@export var file_mode := FileDialog.FileMode.FILE_MODE_SAVE_FILE:
	set(new_value):
		if file_dialog_reference: file_dialog_reference.file_mode = new_value
		file_mode = new_value

@export var filters: PackedStringArray:
	set(new_value):
		if file_dialog_reference: file_dialog_reference.filters = new_value
		filters = new_value

var selected_path := ''


func _ready() -> void:
	file_dialog_reference.file_mode = file_mode
	file_dialog_reference.filters = filters


func _on_select_button_pressed() -> void:
	file_dialog_reference.popup_centered()

func _on_file_dialog_dir_selected(dir: String) -> void:
	line_edit_reference.text = dir
	selected_path = dir

func _on_file_dialog_file_selected(path: String) -> void:
	line_edit_reference.text = path
	selected_path = path
