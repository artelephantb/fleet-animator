@tool
extends Control

signal dir_selected(dir: String)
signal file_selected(path: String)


@onready var select_button_reference := $'LoadButton'
@onready var file_dialog_reference := $'FileDialog'

@export var select_button_text := 'Load':
	set(new_value):
		if select_button_reference: select_button_reference.text = new_value
		select_button_text = new_value

@export var file_mode := FileDialog.FileMode.FILE_MODE_OPEN_FILE:
	set(new_value):
		if file_dialog_reference: file_dialog_reference.file_mode = new_value
		file_mode = new_value

@export var filters: PackedStringArray:
	set(new_value):
		if file_dialog_reference: file_dialog_reference.filters = new_value
		filters = new_value


func _ready() -> void:
	select_button_reference.text = select_button_text
	file_dialog_reference.file_mode = file_mode
	file_dialog_reference.filters = filters


func _on_select_button_pressed() -> void:
	file_dialog_reference.popup_centered()

func _on_file_dialog_dir_selected(dir: String) -> void:
	dir_selected.emit(dir)

func _on_file_dialog_file_selected(path: String) -> void:
	file_selected.emit(path)
