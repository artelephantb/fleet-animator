@tool
class_name PaintCanvas
extends Control


@export var canvas_size := Vector2i(440, 440):
	set(value):
		canvas_size = value

		if value.x <= 0: canvas_size.x = 1
		if value.y <= 0: canvas_size.y = 1

		if canvas_image: canvas_image.crop(canvas_size.x, canvas_size.y)

var canvas_texture_rect_reference: TextureRect

var canvas_image: Image

var is_painting := false

var brush_strokes := []
var stroke_connections := []


func _ready() -> void:
	canvas_image = Image.create_empty(canvas_size.x, canvas_size.y, false, Image.FORMAT_RGBA8)
	canvas_image.fill(Color.WHITE)

	canvas_texture_rect_reference = TextureRect.new()
	canvas_texture_rect_reference.size = canvas_size
	canvas_texture_rect_reference.texture = ImageTexture.create_from_image(canvas_image)

	add_child(canvas_texture_rect_reference)


func handle_mouse_button(event: InputEvent) -> void:
	if !event.pressed:
		if stroke_connections:
			brush_strokes.append(stroke_connections)
			stroke_connections.clear()

		is_painting = false
		return

	if event.button_index == MOUSE_BUTTON_LEFT:
		is_painting = true

func handle_mouse_motion(event: InputEvent) -> void:
	if !is_painting: return

	if stroke_connections:
		create_line(stroke_connections[-1], event.position)
	else:
		canvas_image.fill_rect(Rect2i(event.position.x, event.position.y, 10, 10), Color.BLUE)

	stroke_connections.append(event.position)

	canvas_texture_rect_reference.texture.update(canvas_image)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		handle_mouse_button(event)
		return

	if event is InputEventMouseMotion:
		handle_mouse_motion(event)
		return


func create_line(start_position: Vector2, end_position: Vector2) -> void:
	var line_position := start_position

	while line_position != end_position:
		canvas_image.fill_rect(Rect2i(line_position.x, line_position.y, 10, 10), Color.BLUE)
		line_position = line_position.move_toward(end_position, 1.0)
