extends Window

signal render(output_path: String)


@onready var file_selector_reference := $'VBoxContainer/FileSelector'


func _on_close_requested() -> void:
	hide()

func _on_render_button_pressed() -> void:
	render.emit(file_selector_reference.selected_path)
	hide()
