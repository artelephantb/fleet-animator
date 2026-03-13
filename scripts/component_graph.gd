extends GraphEdit


@onready var component_list_window_reference := $'ComponentListWindow'

var component_types := {
	'on_start_component': preload('res://scenes/graph_components/on_start_component.tscn'),
	'jump_to_position_component': preload('res://scenes/graph_components/jump_to_position_component.tscn'),
	'move_to_position_component': preload('res://scenes/graph_components/move_to_position_component.tscn'),
	'wait_component': preload('res://scenes/graph_components/wait_component.tscn')
}


func _ready() -> void:
	component_list_window_reference.change_title('Add Component')

	component_list_window_reference.add_item('on_start_component', 'On Start Event')
	component_list_window_reference.add_item('jump_to_position_component', 'Jump To Position')
	component_list_window_reference.add_item('move_to_position_component', 'Move To Position')
	component_list_window_reference.add_item('wait_component', 'Wait')

	var add_component_button := Button.new()
	add_component_button.text = 'Add Component'
	get_menu_hbox().add_child(add_component_button)

	add_component_button.connect('pressed', _on_create_component_button_pressed)


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for node in nodes: get_node(NodePath(node)).queue_free()


func _on_create_component_button_pressed() -> void:
	component_list_window_reference.popup_centered()

func _on_add_component_window_close_requested() -> void:
	component_list_window_reference.hide()


func add_component(uid: String, inputs := {}, component_name := str(randi_range(-1000000, 1000000)), position_offset := Vector2(0.0, 0.0)) -> void:
	var new_component: Node = component_types[uid].instantiate()
	new_component.name = component_name
	new_component.set_meta('type', uid)

	new_component.position_offset = position_offset

	add_child(new_component)

	new_component.load_inputs(inputs)

func _on_component_list_window_single_item_selected(uid: String) -> void:
	add_component(uid, {}, str(randi_range(-1000000, 1000000)), scroll_offset + size * 0.5)
	component_list_window_reference.hide()
