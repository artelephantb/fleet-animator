extends GraphEdit


@onready var component_list_window_reference := $'ComponentListWindow'


func _ready() -> void:
	component_list_window_reference.change_title('Add Component')

	var add_component_button := Button.new()
	add_component_button.text = 'Add Component'
	get_menu_hbox().add_child(add_component_button)

	add_component_button.connect('pressed', _on_create_component_button_pressed)

func load_components() -> void:
	component_list_window_reference.remove_all_items()
	for component_id in ExtensionLoader.components:
		component_list_window_reference.add_item(component_id, ExtensionLoader.components[component_id].name)


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
	var new_component := GraphNode.new()
	new_component.set_script(ExtensionLoader.components[uid].script)

	new_component.name = component_name
	new_component.set_meta('type', uid)

	new_component.position_offset = position_offset

	add_child(new_component)

	new_component.load_inputs(inputs)

func _on_component_list_window_single_item_selected(uid: String) -> void:
	add_component(uid, {}, str(randi_range(-1000000, 1000000)), scroll_offset + size * 0.5)
	component_list_window_reference.hide()
