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

func _on_component_list_item_selected(index: int) -> void:
	var new_component: Node = component_types[index].instantiate()
	add_child(new_component)

	add_component_window_reference.hide()
