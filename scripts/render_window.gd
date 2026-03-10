extends Window

signal render(framerate: int, compression: int, output_path: String)


@onready var framerate_spin_box_reference := $'MarginContainer/VBoxContainer/FramerateSpinBox'
@onready var compression_spin_box_reference := $'MarginContainer/VBoxContainer/CompressionSpinBox'
@onready var file_selector_reference := $'MarginContainer/VBoxContainer/FileSelector'


func _on_close_requested() -> void:
	hide()

func _on_render_button_pressed() -> void:
	render.emit(
		framerate_spin_box_reference.value,
		compression_spin_box_reference.value,
		file_selector_reference.selected_path
	)

	hide()
