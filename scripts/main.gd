extends Control


@onready var sprite_tree_reference := $'VBoxContainer/HSplitContainer/SpritesPanelContainer/MarginContainer/VBoxContainer/SpriteTree'
@onready var canvas_reference := $'VBoxContainer/HSplitContainer/VSplitContainer/Control/Canvas'

@onready var inspector_panel_container_reference := $'VBoxContainer/HSplitContainer/InspectorPanelContainer'

@onready var sprite_control_gizmo_reference := $'VBoxContainer/HSplitContainer/VSplitContainer/Control/SpriteControlGizmo'

@onready var create_sprite_type_list_window_reference := $'CreateSpriteTypeListWindow'
@onready var render_popup := $'VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RenderButton/RenderWindow'
@onready var save_popup := $'SaveWindow'

@onready var components_graph_reference := $'VBoxContainer/HSplitContainer/VSplitContainer/PanelContainer/ManipulationComponentGraphEdit'

@onready var root: TreeItem = sprite_tree_reference.create_item()

var animation_data := {}
var animation_variables := {}

var selected_sprite_uid: String

var sprite_types := {
	'texture_sprite': {
		'icon': preload('res://icons/texture_sprite.svg'),
		'scene': preload('res://scenes/sprites/TextureSprite.tscn')
	}
}

var playing_animation := false

var part_temp_directory: DirAccess
var part_temp_directory_location: String

var rendering_animation := false
var animation_output_path: String

var animation_frame := 0

var animation_framerate := '24'
var animation_compression := '18'
var animation_codec := 'libx264'

var frame_length := 100
var frame_digits := 3

var play_component_cache := {}

var play_component_mappings := {
	'on_start_component': 'res://scripts/play_components/on_start_component.gd',
	'jump_to_position_component': 'res://scripts/play_components/jump_to_position_component.gd',
	'move_to_position_component': 'res://scripts/play_components/move_to_position_component.gd',
	'wait_component': 'res://scripts/play_components/wait_component.gd'
}

var project_name := 'New Project'
var project_location: String
var project_config: ConfigFile


func _ready() -> void:
	create_sprite_type_list_window_reference.change_title('Create New Sprite')
	for sprite_type in sprite_types:
		create_sprite_type_list_window_reference.add_item(sprite_type, sprite_type.capitalize(), sprite_types[sprite_type].icon)

	part_temp_directory_location = ProjectSettings.globalize_path('user://part_temp')
	DirAccess.make_dir_recursive_absolute(part_temp_directory_location)
	part_temp_directory = DirAccess.open(part_temp_directory_location)


func get_placehold_and_filled_digits(digits: int, number: int) -> String:
	var number_string := str(number)
	var needed_placeholders := digits - len(number_string)

	return '0'.repeat(needed_placeholders) + number_string


func run_component(component_uid: String, type: int, sprite: Node, inputs: Dictionary, active_variables: Dictionary) -> bool:
	if type not in play_component_cache:
		play_component_cache[type] = load(play_component_mappings[type])

	return play_component_cache[type].run(
		component_uid,
		sprite,
		inputs,
		active_variables
	)


func update_play_animation() -> void:
	var finnished_sprites := 0

	for sprite_uid in animation_data:
		var data: Dictionary = animation_data[sprite_uid]

		if len(data.active_components) == 0:
			finnished_sprites += 1

		var to_remove := []

		for component_index in len(data.active_components):
			var component_uid: String = data.active_components[component_index]
			var component: Dictionary = data.components[component_uid]

			if component_uid not in animation_variables:
				animation_variables[component_uid] = {}

			if component.type not in play_component_cache:
				play_component_cache[component.type] = load(play_component_mappings[component.type])

			var is_done: bool = play_component_cache[component.type].run(
				component_uid,
				canvas_reference.get_sprite(sprite_uid),
				component.inputs,
				animation_variables[component_uid]
			)

			if !is_done: continue

			# When component finnished
			for connection_index in len(data.connections):
				var connection: Dictionary = data.connections[connection_index]
				if connection.from_node != component_uid: continue

				data.active_components.append(connection.to_node)

			to_remove.append(component_index)

		# Remove old components
		var removed_amount := 0
		for index in to_remove:
			data.active_components.remove_at(index - removed_amount)
			removed_amount += 1

	if finnished_sprites == len(animation_data):
		sprite_control_gizmo_reference.disabled = false
		playing_animation = false

func update_render_animation() -> void:
	update_play_animation()

	if animation_output_path:
		canvas_reference.sub_viewport_reference.get_texture().get_image().save_png(part_temp_directory_location + '/%s.png' % get_placehold_and_filled_digits(frame_digits, animation_frame))

	animation_frame += 1

	if playing_animation: return
	rendering_animation = false

	if animation_output_path:
		OS.execute('ffmpeg', [
			'-framerate',
			animation_framerate,
			'-i',
			part_temp_directory_location + '/%' + get_placehold_and_filled_digits(2, frame_digits) + 'd.png',
			'-crf',
			animation_compression,
			'-c:v',
			animation_codec,
			'-pix_fmt',
			'yuv420p',
			animation_output_path
		], [], true)

func _process(delta: float) -> void:
	if rendering_animation: update_render_animation()
	elif playing_animation: update_play_animation()


func create_sprite(type: String, sprite_name: String) -> void:
	var sprite_type_info: Dictionary = sprite_types[type]

	var new_sprite_item: TreeItem = sprite_tree_reference.create_item(root)
	var sprite_uid := str(randi_range(-1000000, 1000000))

	new_sprite_item.set_editable(0, true)

	new_sprite_item.set_text(0, sprite_name)
	new_sprite_item.set_icon(0, sprite_type_info.icon)

	new_sprite_item.set_meta('uid', sprite_uid)
	new_sprite_item.set_meta('type', type)

	animation_data[sprite_uid] = {
		'components': {},
		'active_components': [],
		'connections': []
	}

	var sprite = sprite_type_info.scene.instantiate()
	sprite.name = sprite_uid
	canvas_reference.sub_viewport_reference.add_child(sprite)

func _on_create_sprite_button_pressed() -> void:
	create_sprite_type_list_window_reference.popup_centered()

func _on_create_sprite_type_list_window_single_item_selected(type: String) -> void:
	create_sprite(type, 'New Sprite')


func save_components(sprite_uid: String) -> void:
	var data := {
		'components': {},
		'active_components': [],
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

	inspector_panel_container_reference.remove_all_properties()

	inspector_panel_container_reference.add_property('position', selected_node.position, [], func(new_value: Vector2):
		selected_node.position = new_value
	)

	inspector_panel_container_reference.add_property('scale', selected_node.scale, [], func(new_value: Vector2):
		selected_node.scale = new_value
	)

	inspector_panel_container_reference.add_property('rotation', selected_node.rotation, [], func(new_value: float):
		selected_node.rotation = new_value
	)


func _on_render_button_pressed() -> void:
	render_popup.popup_centered()


func play_animation() -> void:
	if playing_animation or rendering_animation: return

	if selected_sprite_uid:
		save_components(selected_sprite_uid)

	for sprite_uid in animation_data:
		var data: Dictionary = animation_data[sprite_uid]

		for component_uid in data.components:
			var component: Dictionary = data.components[component_uid]

			if component.type == 'on_start_component':
				data.active_components.append(component_uid)

	animation_variables.clear()
	sprite_control_gizmo_reference.disabled = true

	playing_animation = true

func _on_play_button_pressed() -> void:
	play_animation()


func _on_project_popup_menu_id_pressed(id: int) -> void:
	match id:
		0:
			save_popup.popup_centered()

func _on_animation_popup_menu_id_pressed(id: int) -> void:
	match id:
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
	if playing_animation or rendering_animation: return

	animation_frame = 0

	animation_framerate = str(framerate)
	animation_compression = str(compression)

	remove_recursive_directory(part_temp_directory.get_current_dir())
	DirAccess.make_dir_recursive_absolute(part_temp_directory_location)

	if FileAccess.file_exists(output_path):
		DirAccess.remove_absolute(output_path)

	if selected_sprite_uid:
		save_components(selected_sprite_uid)

	for sprite_uid in animation_data:
		var data: Dictionary = animation_data[sprite_uid]

		for component_uid in data.components:
			var component: Dictionary = data.components[component_uid]

			if component.type == 0: # 0 is on_start_component
				data.active_components.append(component_uid)

	animation_variables.clear()
	sprite_control_gizmo_reference.disabled = true

	animation_output_path = output_path
	rendering_animation = true
	playing_animation = true

func _on_render_window_render(framerate: int, compression: int, output_path: String) -> void:
	if !output_path: return
	render_animation(framerate, compression, output_path)


func save_sprites() -> void:
	if selected_sprite_uid: save_components(selected_sprite_uid)

	var sprites := {}

	for sprite_uid in animation_data:
		var sprite: Node = canvas_reference.get_sprite(sprite_uid)
		sprite.export(project_location)

		var sprite_animation_data: Dictionary = animation_data[sprite_uid]

		sprites[sprite_uid] = {
			'components': sprite_animation_data.components,
			'connections': sprite_animation_data.connections
		}

	var encoded_sprites := JSON.stringify(JSON.from_native(sprites))

	var file_access := FileAccess.open(project_location + '/res/scenes/main.json', FileAccess.WRITE)
	file_access.store_string(encoded_sprites)


func save_new_project(name: String, location: String) -> void:
	project_name = name
	project_location = location

	DirAccess.make_dir_recursive_absolute(project_location)

	DirAccess.make_dir_absolute(project_location + '/res')
	DirAccess.make_dir_absolute(project_location + '/res/scenes')
	DirAccess.make_dir_absolute(project_location + '/res/textures')

	project_config = ConfigFile.new()
	project_config.set_value('project', 'name', project_name)
	project_config.save(project_location + '/project.cfg')

	save_sprites()

func _on_save_window_save_as(name: String, location: String) -> void:
	save_new_project(name, location)


func _on_sprite_control_gizmo_handle_pressed(handle: int) -> void:
	var mouse_position: Vector2 = sprite_control_gizmo_reference.get_local_mouse_position()

	match handle:
		sprite_control_gizmo_reference.handle_locations.MIDDLE:
			sprite_control_gizmo_reference.selected_node.position = mouse_position + sprite_control_gizmo_reference.position_offset
			inspector_panel_container_reference.set_property_value('position', sprite_control_gizmo_reference.selected_node.position)

		sprite_control_gizmo_reference.handle_locations.LEFT:
			sprite_control_gizmo_reference.selected_node.scale.x = mouse_position.x + sprite_control_gizmo_reference.position_offset.x
			inspector_panel_container_reference.set_property_value('scale', sprite_control_gizmo_reference.selected_node.scale)

		sprite_control_gizmo_reference.handle_locations.RIGHT:
			sprite_control_gizmo_reference.selected_node.position.x = mouse_position.x + sprite_control_gizmo_reference.position_offset.x
			inspector_panel_container_reference.set_property_value('position', sprite_control_gizmo_reference.selected_node.position)

		sprite_control_gizmo_reference.handle_locations.UP:
			sprite_control_gizmo_reference.selected_node.scale.y = mouse_position.y + sprite_control_gizmo_reference.position_offset.y
			inspector_panel_container_reference.set_property_value('scale', sprite_control_gizmo_reference.selected_node.scale)

		sprite_control_gizmo_reference.handle_locations.DOWN:
			sprite_control_gizmo_reference.selected_node.position.y = mouse_position.y + sprite_control_gizmo_reference.position_offset.y
			inspector_panel_container_reference.set_property_value('position', sprite_control_gizmo_reference.selected_node.position)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('project_save_as'):
		save_popup.popup_centered()
