extends Node


@onready var editor_scene := preload('res://scenes/main.tscn')


func create_new_project_new_window() -> void:
	var window := Window.new()
	var editor := editor_scene.instantiate()

	window.extend_to_title = true
	window.size = Vector2(1920, 1080)
	window.close_requested.connect(func ():
		window.queue_free()
	)

	window.add_child(editor)
	get_tree().root.add_child(window)

	window.move_to_center()

func load_project_new_window(path: String) -> void:
	var window := Window.new()
	var editor := editor_scene.instantiate()

	window.size = Vector2(1920, 1080)
	window.close_requested.connect(func ():
		window.queue_free()
	)

	window.add_child(editor)
	get_tree().root.add_child(window)

	window.move_to_center()

	editor.load_project(path)
