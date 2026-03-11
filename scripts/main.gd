extends Control


@onready var sprite_tree_reference := $'VBoxContainer/HSplitContainer/PanelContainer/MarginContainer/VBoxContainer/SpriteTree'
@onready var canvas_reference := $'VBoxContainer/HSplitContainer/VSplitContainer/Control/Canvas'

@onready var sprite_control_gizmo_reference := $'VBoxContainer/HSplitContainer/VSplitContainer/Control/SpriteControlGizmo'

@onready var render_popup := $'VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RenderButton/RenderWindow'

@onready var components_graph_reference := $'VBoxContainer/HSplitContainer/VSplitContainer/PanelContainer/ManipulationComponentGraphEdit'

@onready var sprite_icon_image := preload('res://icons/sprite.svg')
@onready var missing_texture := preload('res://icon.svg')

@onready var root: TreeItem = sprite_tree_reference.create_item()

var animation_data := {}
var animation_active_components := []
var animation_active_components_variables := {}

var selected_sprite_uid: String

var playing_animation := false

var part_temp_directory: DirAccess
var part_temp_directory_location: String

var rendering_animation := false
var animation_output_path: String

var animation_frame := 0

var animation_framerate := '24'
var animation_compression := '18'
var animation_codec := 'libx264'


func _ready() -> void:
	part_temp_directory_location = ProjectSettings.globalize_path('user://part_temp')
	DirAccess.make_dir_recursive_absolute(part_temp_directory_location)
	part_temp_directory = DirAccess.open(part_temp_directory_location)


func run_component(component_uid: String, type: int, sprite: Node, inputs: Dictionary) -> bool:
	match type:
		0: # On Start Event
			return true
		1: # Jump To Position
			sprite.position = inputs.position
			return true
		2: # Wait
			if component_uid not in animation_active_components_variables:
				animation_active_components_variables[component_uid] = {
					'time_left': int(inputs.time)
				}
				return false

			var variables: Dictionary = animation_active_components_variables[component_uid]
			variables.time_left -= 1

			if variables.time_left > 0:
				return false

			return true

	push_error('Invalid type: ', type)
	return true


func update_play_animation() -> void:
	if len(animation_active_components) == 0:
		sprite_control_gizmo_reference.disabled = false
		playing_animation = false

	for sprite_uid in animation_data:
		var data: Dictionary = animation_data[sprite_uid]

		var to_remove := []

		for component_index in len(animation_active_components):
			var component_uid: String = animation_active_components[component_index]
			var component: Dictionary = data.components[component_uid]

			var is_done := run_component(component_uid, component.type, canvas_reference.get_sprite(sprite_uid), component.inputs)
			if !is_done: continue

			# When component finnished
			for connection_index in len(data.connections):
				var connection: Dictionary = data.connections[connection_index]
				if connection.from_node != component_uid: continue

				animation_active_components.append(connection.to_node)

			to_remove.append(component_index)

		# Remove old components
		var removed_amount := 0
		for index in to_remove:
			animation_active_components.remove_at(index - removed_amount)
			removed_amount += 1

func update_render_animation() -> void:
	if animation_output_path:
		canvas_reference.sub_viewport_reference.get_texture().get_image().save_png(part_temp_directory_location + '/%d.png' % animation_frame)

	animation_frame += 1

	if animation_frame < 1000: return
	rendering_animation = false

	if animation_output_path:
		OS.execute('ffmpeg', [
			'-framerate',
			animation_framerate,
			'-pattern_type',
			'glob',
			'-i',
			part_temp_directory_location + '/*.png',
			'-crf',
			animation_compression,
			'-c:v',
			animation_codec,
			animation_output_path
		], [], true)

func _process(delta: float) -> void:
	if playing_animation: update_play_animation()
	elif rendering_animation: update_render_animation()


func create_sprite(sprite_name: String, sprite_icon := sprite_icon_image) -> TreeItem:
	var new_sprite_item: TreeItem = sprite_tree_reference.create_item(root)
	var sprite_uid := str(randi_range(-1000000, 1000000))

	new_sprite_item.set_editable(0, true)

	new_sprite_item.set_text(0, sprite_name)
	new_sprite_item.set_icon(0, sprite_icon)

	new_sprite_item.set_meta('uid', sprite_uid)
	animation_data[sprite_uid] = {
		'components': {},
		'connections': []
	}

	canvas_reference.create_texture_sprite(sprite_uid, missing_texture)

	return new_sprite_item

func _on_create_sprite_button_pressed() -> void:
	create_sprite('New Sprite')


func save_components(sprite_uid: String) -> void:
	var data := {
		'components': {},
		'connections': components_graph_reference.get_connection_list()
	}

	for child in components_graph_reference.get_children():
		if child is not GraphNode: continue

		data.components[child.name] = {
			'type': child.get_meta('type'),
			'position_offset': child.position_offset,
			'inputs': child.get_inputs()
		}

	animation_data[sprite_uid] = data

func load_components(sprite_data: Dictionary) -> void:
	# Remove previous components
	for child in components_graph_reference.get_children():
		if child is not GraphNode: continue
		child.queue_free()

	# Introduce new components
	var components: Dictionary = sprite_data.components
	var connections: Array = sprite_data.connections

	for component_uid in components:
		var component: Dictionary = components[component_uid]
		components_graph_reference.add_component(component.type, component.inputs, component_uid, component.position_offset)

	for connection in connections:
		components_graph_reference.connect_node(connection.from_node, connection.from_port, connection.to_node, connection.to_port, connection.keep_alive)


func _on_sprite_tree_item_selected() -> void:
	var selected_item: TreeItem = sprite_tree_reference.get_selected()
	var item_uid: String = selected_item.get_meta('uid')
	var selected_node: Node2D = canvas_reference.get_sprite(item_uid)

	if selected_sprite_uid:
		save_components(selected_sprite_uid)

	selected_sprite_uid = item_uid
	load_components(animation_data[item_uid])

	sprite_control_gizmo_reference.selected_node = selected_node


func _on_render_button_pressed() -> void:
	render_popup.popup_centered()


func play_animation() -> void:
	if selected_sprite_uid:
		save_components(selected_sprite_uid)

	for sprite_uid in animation_data:
		var data: Dictionary = animation_data[sprite_uid]

		for component_uid in data.components:
			var component: Dictionary = data.components[component_uid]

			if component.type == 0: # 0 is on_start_component
				animation_active_components.append(component_uid)

	animation_active_components_variables.clear()
	sprite_control_gizmo_reference.disabled = true

	playing_animation = true

func _on_play_button_pressed() -> void:
	play_animation()


func _on_popup_menu_index_pressed(index: int) -> void:
	match index:
		0:
			play_animation()
		1:
			render_popup.popup_centered()


func remove_recursive_directory(directory: String) -> void:
	for directory_name in DirAccess.get_directories_at(directory):
		remove_recursive_directory(directory.path_join(directory_name))
	for file_name in DirAccess.get_files_at(directory):
		DirAccess.remove_absolute(directory.path_join(file_name))

	DirAccess.remove_absolute(directory)


func render_animation(framerate: int, compression: int, output_path: String) -> void:
	animation_frame = 0

	animation_framerate = str(framerate)
	animation_compression = str(compression)

	remove_recursive_directory(part_temp_directory.get_current_dir())
	DirAccess.make_dir_recursive_absolute(part_temp_directory_location)

	if FileAccess.file_exists(output_path):
		DirAccess.remove_absolute(output_path)

	animation_output_path = output_path
	rendering_animation = true

func _on_render_window_render(framerate: int, compression: int, output_path: String) -> void:
	if !output_path: return
	render_animation(framerate, compression, output_path)
