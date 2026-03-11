extends GraphEdit


@onready var add_component_window_reference := $'AddComponentWindow'

var component_types := [
	preload('res://scenes/components/on_start_component.tscn'),
	preload('res://scenes/components/jump_to_position_component.tscn')
]


func _ready() -> void:
	var add_component_button := Button.new()
	add_component_button.text = 'Add Component'
	get_menu_hbox().add_child(add_component_button)

	add_component_button.connect('pressed', _on_create_component_button_pressed)


func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	connect_node(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	disconnect_node(from_node, from_port, to_node, to_port)


func _on_create_component_button_pressed() -> void:
	add_component_window_reference.popup_centered()

func _on_add_component_window_close_requested() -> void:
	add_component_window_reference.hide()


func add_component(index: int, component_name := str(randi_range(-1000000, 1000000)), position_offset := Vector2(0.0, 0.0)) -> void:
	var new_component: Node = component_types[index].instantiate()
	new_component.name = component_name
	new_component.set_meta('type', index)

	new_component.position_offset = position_offset

	add_child(new_component)

func _on_component_list_item_selected(index: int) -> void:
	add_component(index)
	add_component_window_reference.hide()
