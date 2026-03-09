extends Control


@export var file_mode := FileDialog.FileMode.FILE_MODE_SAVE_FILE
@export var filters: PackedStringArray

@onready var file_dialog_reference := $'FileDialog'
@onready var line_edit_reference := $'LineEdit'

var selected_path := ''


func update_file_mode():
	file_dialog_reference.file_mode = file_mode
	file_dialog_reference.filters = filters

func _ready() -> void:
	update_file_mode()


func _on_select_button_pressed() -> void:
	file_dialog_reference.popup_centered()

func _on_file_dialog_dir_selected(dir: String) -> void:
	line_edit_reference.text = dir
	selected_path = dir

func _on_file_dialog_file_selected(path: String) -> void:
	line_edit_reference.text = path
	selected_path = path
