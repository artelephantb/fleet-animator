@tool
extends Control

signal path_selected(path: String)


@onready var select_button_reference := $'SelectButton'
@onready var line_edit_reference := $'LineEdit'
@onready var file_dialog_reference := $'FileDialog'

@export var file_mode := FileDialog.FileMode.FILE_MODE_SAVE_FILE:
	set(new_value):
		if file_dialog_reference: file_dialog_reference.file_mode = new_value
		file_mode = new_value

@export var selected_path: String:
	set(new_value):
		path_selected.emit(new_value)

		if line_edit_reference: line_edit_reference.text = new_value
		selected_path = new_value

@export var select_button_text := 'Select':
	set(new_value):
		if select_button_reference: select_button_reference.text = new_value
		select_button_text = new_value

@export var filters: PackedStringArray:
	set(new_value):
		if file_dialog_reference: file_dialog_reference.filters = new_value
		filters = new_value


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

func _on_line_edit_editing_toggled(toggled_on: bool) -> void:
	if !toggled_on: selected_path = line_edit_reference.text
