extends GraphEdit


@onready var component_popup_menu := $'ComponentPopupMenu'

var component_catagory_mappings: PackedStringArray = []
var component_id_mappings: PackedStringArray = []


func _ready() -> void:
	var add_component_button := Button.new()
	add_component_button.text = 'Add Component'
	get_menu_hbox().add_child(add_component_button)

	add_component_button.connect('pressed', _on_create_component_button_pressed)

func load_components() -> void:
	component_popup_menu.clear()
	component_catagory_mappings.clear()
	component_id_mappings.clear()

	for catagory_id in AnimationEngine.component_catagories:
		var catagory = AnimationEngine.component_catagories[catagory_id]
		for name_id in catagory.component_names:
			component_popup_menu.add_item(catagory.component_names[name_id])
			component_catagory_mappings.append(catagory_id)
			component_id_mappings.append(name_id)


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for node in nodes: get_node(NodePath(node)).queue_free()


func _on_create_component_button_pressed() -> void:
	component_popup_menu.popup(Rect2(DisplayServer.mouse_get_position(), Vector2(0.0, 0.0)))


func add_component(id: int, inputs := {}, component_uid := str(randi_range(-1000000, 1000000)), position_offset := Vector2(0.0, 0.0)) -> void:
	var new_component := GraphComponent.new(
		component_catagory_mappings[id],
		component_id_mappings[id]
	)

	new_component.name = component_uid
	new_component.position_offset = position_offset

	add_child(new_component)

	new_component.set_inputs(inputs)

func _on_component_popup_menu_id_pressed(id: int) -> void:
	add_component(id, {}, str(randi_range(-1000000, 1000000)), scroll_offset + size * 0.5)
