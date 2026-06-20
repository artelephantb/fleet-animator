extends GraphEdit


@onready var component_popup_menu := $'ComponentPopupMenu'


func _ready() -> void:
	var add_component_button := Button.new()
	add_component_button.text = 'Add Component'
	get_menu_hbox().add_child(add_component_button)

	add_component_button.connect('pressed', _on_create_component_button_pressed)

func load_components() -> void:
	component_popup_menu.clear()
	for id in len(ExtensionLoader.components):
		component_popup_menu.add_item(ExtensionLoader.components[id].name, id)


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for node in nodes: get_node(NodePath(node)).queue_free()


func _on_create_component_button_pressed() -> void:
	component_popup_menu.popup(Rect2(DisplayServer.mouse_get_position(), Vector2(0.0, 0.0)))


func add_component(id: int, inputs := {}, component_name := str(randi_range(-1000000, 1000000)), position_offset := Vector2(0.0, 0.0)) -> void:
	var new_component := GraphNode.new()
	new_component.set_script(ExtensionLoader.components[id].script)

	new_component.name = component_name
	new_component.set_meta('id', id)

	new_component.position_offset = position_offset

	add_child(new_component)

	new_component.load_inputs(inputs)

func _on_component_popup_menu_id_pressed(id: int) -> void:
	add_component(id, {}, str(randi_range(-1000000, 1000000)), scroll_offset + size * 0.5)
