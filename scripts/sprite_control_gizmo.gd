extends Control


@export var disabled := false
@export var selected_node: Node2D

var handle_distance := 50.0

var handle_radius := 15.0
var handle_border_radius := handle_radius + 5.0

var hovered_handle := -1
var pressed_handle := -1

var position_offset := Vector2(0.0, 0.0)


var color_drag := Color(0.2, 0.2, 0.2)
var color_drag_x := Color(0.0, 1.0, 0.3, 1.0)
var color_drag_y := Color(1.0, 0.1, 0.1)

var color_scale := Color(0.5, 0.0, 1.0)
var color_scale_x := Color(1.0, 0.9, 0.2)
var color_scale_y := Color(0.0, 0.3, 1.0, 1.0)

var color_disabled := Color(0.191, 0.191, 0.191, 0.58)


func _ready() -> void:
	pass

func update_handles() -> void:
	var mouse_position := get_local_mouse_position()
	var distance := selected_node.position - mouse_position

	if abs(distance.x) <= handle_border_radius and abs(distance.y) <= handle_border_radius:
		hovered_handle = 0
		return

	if abs(distance.x - handle_distance) <= handle_border_radius and abs(distance.y) <= handle_border_radius:
		hovered_handle = 1
		return

	if abs(distance.x + handle_distance) <= handle_border_radius and abs(distance.y) <= handle_border_radius:
		hovered_handle = 2
		return

	if abs(distance.x) <= handle_border_radius and abs(distance.y - handle_distance) <= handle_border_radius:
		hovered_handle = 3
		return

	if abs(distance.x) <= handle_border_radius and abs(distance.y + handle_distance) <= handle_border_radius:
		hovered_handle = 4
		return

	hovered_handle = -1

func update_selected_sprite() -> void:
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pressed_handle = -1
		return

	var mouse_position := get_local_mouse_position()

	if pressed_handle == -1:
		pressed_handle = hovered_handle
		position_offset = selected_node.position - mouse_position

	match pressed_handle:
		-1: pass
		0: selected_node.position = mouse_position + position_offset
		1: selected_node.scale.x = mouse_position.x + position_offset.x
		2: selected_node.position.x = mouse_position.x + position_offset.x
		3: selected_node.scale.y = mouse_position.y + position_offset.y
		4: selected_node.position.y = mouse_position.y + position_offset.y

func _process(delta: float) -> void:
	if !disabled and selected_node:
		update_handles()
		update_selected_sprite()

	queue_redraw()


func draw_node_handles(node: Node2D) -> void:
	var left_handle_position := Vector2(node.position.x - handle_distance, node.position.y)
	var right_handle_position := Vector2(node.position.x + handle_distance, node.position.y)
	var top_handle_position := Vector2(node.position.x, node.position.y - handle_distance)
	var bottom_handle_position := Vector2(node.position.x, node.position.y + handle_distance)

	match hovered_handle:
		0:
			draw_circle(node.position, handle_border_radius, Color.WHITE)
		1:
			draw_circle(left_handle_position, handle_border_radius, Color.WHITE)
		2:
			draw_circle(right_handle_position, handle_border_radius, Color.WHITE)
		3:
			draw_circle(top_handle_position, handle_border_radius, Color.WHITE)
		4:
			draw_circle(bottom_handle_position, handle_border_radius, Color.WHITE)

	if disabled:
		draw_circle(node.position, handle_radius, color_disabled)
		draw_circle(left_handle_position, handle_radius, color_disabled)
		draw_circle(right_handle_position, handle_radius, color_disabled)
		draw_circle(top_handle_position, handle_radius, color_disabled)
		draw_circle(bottom_handle_position, handle_radius, color_disabled)
	else:
		draw_circle(node.position, handle_radius, color_drag)
		draw_circle(left_handle_position, handle_radius, color_scale_x)
		draw_circle(right_handle_position, handle_radius, color_drag_x)
		draw_circle(top_handle_position, handle_radius, color_scale_y)
		draw_circle(bottom_handle_position, handle_radius, color_drag_y)

func _draw() -> void:
	if selected_node: draw_node_handles(selected_node)
