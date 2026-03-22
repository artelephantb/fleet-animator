extends Window

signal save_image(image: Image)


@onready var paint_editor_reference := $'MarginContainer/VBoxContainer/PaintEditor'


func _on_close_requested() -> void:
	hide()

func _on_save_button_pressed() -> void:
	save_image.emit(paint_editor_reference.canvas_image)
	hide()
