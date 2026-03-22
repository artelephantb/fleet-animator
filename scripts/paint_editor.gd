@tool
class_name PaintEditor
extends Control


@export var canvas_size := Vector2i(440, 440):
	set(value):
		canvas_size = value

		if value.x <= 0: canvas_size.x = 1
		if value.y <= 0: canvas_size.y = 1

		if not canvas_image: return

		canvas_image.crop(canvas_size.x, canvas_size.y)
		canvas_texture_rect_reference.texture = ImageTexture.create_from_image(canvas_image)
		canvas_background_rect_reference.custom_minimum_size = canvas_size
		size.x = canvas_size.x + color_picker_reference.size.x

		if color_picker_reference.size.y > canvas_size.y:
			size.y = color_picker_reference.size.y
		else:
			size.y = canvas_size.y

@onready var checkerboard_pattern_texture := preload('res://checkerboard.png')

var color_picker_reference: ColorPicker
var canvas_background_rect_reference: TextureRect
var canvas_texture_rect_reference: TextureRect

var canvas_image: Image

var is_painting := false

var brush_strokes := []
var removed_brushed_strokes := []
var stroke_connections := []

var brush_color := Color.BLACK
var brush_size := 10


func _ready() -> void:
	clip_contents = true

	var h_box_container := HBoxContainer.new()
	h_box_container.set_anchors_preset(Control.PRESET_FULL_RECT)

	#region Color Picker
	color_picker_reference = ColorPicker.new()
	color_picker_reference.color = Color.BLACK

	color_picker_reference.connect('color_changed', change_brush_color)
	color_picker_reference.size_flags_vertical = 0

	h_box_container.add_child(color_picker_reference)
	#endregion

	var v_box_container := VBoxContainer.new()
	v_box_container.set_anchors_preset(Control.PRESET_FULL_RECT)

	#region Menu Bar: Brush Size
	var brush_size_container := HBoxContainer.new()

	var brush_size_label := Label.new()
	brush_size_label.text = 'Size'

	brush_size_container.add_child(brush_size_label)

	var brush_size_spin_box := SpinBox.new()
	brush_size_spin_box.set_value_no_signal(brush_size)
	brush_size_spin_box.max_value = 10000.0
	brush_size_spin_box.allow_greater = true

	brush_size_spin_box.connect('value_changed', change_brush_size)

	brush_size_container.add_child(brush_size_spin_box)

	v_box_container.add_child(brush_size_container)
	#endregion

	var editor_container := PanelContainer.new()
	editor_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	editor_container.size_flags_vertical = Control.SIZE_EXPAND_FILL

	#region Background Texture Rect
	canvas_background_rect_reference = TextureRect.new()
	canvas_background_rect_reference.expand_mode = TextureRect.EXPAND_IGNORE_SIZE

	canvas_background_rect_reference.size_flags_horizontal = 0
	canvas_background_rect_reference.size_flags_vertical = 0

	canvas_background_rect_reference.custom_minimum_size = canvas_size

	canvas_background_rect_reference.texture = checkerboard_pattern_texture
	canvas_background_rect_reference.stretch_mode = TextureRect.STRETCH_TILE

	editor_container.add_child(canvas_background_rect_reference)
	#endregion

	#region Canvas
	canvas_image = Image.create_empty(canvas_size.x, canvas_size.y, false, Image.FORMAT_RGBA8)

	canvas_texture_rect_reference = TextureRect.new()
	canvas_texture_rect_reference.texture = ImageTexture.create_from_image(canvas_image)

	canvas_texture_rect_reference.set_focus_mode(Control.FOCUS_CLICK)

	canvas_texture_rect_reference.connect('gui_input', canvas_input)

	canvas_background_rect_reference.add_child(canvas_texture_rect_reference)
	#endregion

	v_box_container.add_child(editor_container)
	h_box_container.add_child(v_box_container)
	add_child(h_box_container)


func handle_mouse_button(event: InputEvent) -> void:
	if !event.pressed:
		if stroke_connections:
			brush_strokes.append(stroke_connections.duplicate())
			stroke_connections.clear()

		is_painting = false
		return

	if event.button_index == MOUSE_BUTTON_LEFT:
		is_painting = true

func handle_mouse_motion(event: InputEvent) -> void:
	if !is_painting: return

	if stroke_connections:
		create_line(stroke_connections[-1][0], event.position, brush_color)
	else:
		canvas_image.fill_rect(Rect2i(event.position.x, event.position.y, brush_size, brush_size), brush_color)

	stroke_connections.append([event.position, brush_color])
	canvas_texture_rect_reference.texture.update(canvas_image)

func canvas_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		handle_mouse_button(event)
		return

	if event is InputEventMouseMotion:
		handle_mouse_motion(event)
		return


func draw_brush_strokes(strokes: Array) -> void:
	canvas_image = Image.create_empty(canvas_image.get_width(), canvas_image.get_height(), false, Image.FORMAT_RGBA8)

	for stroke in strokes:
		var point_index := 1
		while point_index < len(stroke):
			var start_connection: Array = stroke[point_index - 1]
			var end_connection: Array = stroke[point_index]
			create_line(start_connection[0], end_connection[0], end_connection[1])

			point_index += 1

	canvas_texture_rect_reference.texture.update(canvas_image)

func undo() -> void:
	if len(brush_strokes) == 0: return

	removed_brushed_strokes.append(brush_strokes[-1])
	brush_strokes.remove_at(-1)
	draw_brush_strokes(brush_strokes)

func redo() -> void:
	if len(removed_brushed_strokes) == 0: return

	brush_strokes.append(removed_brushed_strokes[-1])
	removed_brushed_strokes.remove_at(-1)
	draw_brush_strokes(brush_strokes)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('ui_redo'):
		if get_viewport().gui_get_focus_owner() == canvas_texture_rect_reference:
			redo()
		return

	if Input.is_action_just_pressed('ui_undo'):
		if get_viewport().gui_get_focus_owner() == canvas_texture_rect_reference:
			undo()
		return


func change_brush_color(color: Color) -> void:
	brush_color = color

func change_brush_size(new_size: int) -> void:
	brush_size = new_size


func create_line(start_position: Vector2, end_position: Vector2, color: Color) -> void:
	var line_position := start_position

	while line_position != end_position:
		canvas_image.fill_rect(Rect2i(line_position.x, line_position.y, brush_size, brush_size), color)
		line_position = line_position.move_toward(end_position, 1.0)
