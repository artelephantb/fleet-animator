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


func _ready() -> void:
	canvas_image = Image.create_empty(canvas_size.x, canvas_size.y, false, Image.FORMAT_RGBA8)
	canvas_image.fill(Color.WHITE)

	canvas_texture_rect_reference = TextureRect.new()
	canvas_texture_rect_reference.size = canvas_size
	canvas_texture_rect_reference.texture = ImageTexture.create_from_image(canvas_image)

	add_child(canvas_texture_rect_reference)

func handle_mouse_button(event: InputEvent) -> void:
	if !event.pressed:
		is_painting = false
		return

	if event.button_index == MOUSE_BUTTON_LEFT:
		is_painting = true

func handle_mouse_motion(event: InputEvent) -> void:
	if !is_painting: return

	canvas_image.fill_rect(Rect2i(event.position.x, event.position.y, 10, 10), Color.BLUE)
	canvas_texture_rect_reference.texture.update(canvas_image)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		handle_mouse_button(event)
		return

	if event is InputEventMouseMotion:
		handle_mouse_motion(event)
		return
