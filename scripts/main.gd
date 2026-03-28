extends Control


@onready var toolbar_reference := $'VBoxContainer/HSplitContainer/VSplitContainer/Control/Toolbar'

@onready var sprite_tree_reference := $'VBoxContainer/HSplitContainer/SpritesPanelContainer/MarginContainer/VBoxContainer/SpriteTree'
@onready var canvas_reference := $'VBoxContainer/HSplitContainer/VSplitContainer/Control/Canvas'

@onready var inspector_panel_container_reference := $'VBoxContainer/HSplitContainer/InspectorPanelContainer'

@onready var sprite_control_gizmo_reference := $'VBoxContainer/HSplitContainer/VSplitContainer/Control/SpriteControlGizmo'

@onready var create_sprite_type_list_window_reference := $'CreateSpriteTypeListWindow'
@onready var render_window := $'VBoxContainer/TopBarPanelContainer/RightMarginContainer/HBoxContainer/RenderButton/RenderWindow'

@onready var save_window := $'SaveWindow'
@onready var load_window := $'LoadWindow'

@onready var extensions_manager_window_reference := $'ExtensionsManagerWindow'

@onready var components_graph_reference := $'VBoxContainer/HSplitContainer/VSplitContainer/PanelContainer/ManipulationComponentGraphEdit'

@onready var root: TreeItem = sprite_tree_reference.create_item()

var animation_data := {}
var animation_variables := {}

var selected_sprite_uid: String
var selected_sprite_item: TreeItem

var sprite_types := {
	'costume_sprite': {
		'icon': preload('res://icons/costume_sprite.svg'),
		'scene': preload('res://scenes/sprites/CostumeSprite.tscn')
	}
}

var playing_animation := false

var part_temp_directory: DirAccess
var part_temp_directory_location: String

var rendering_animation := false
var animation_output_path: String

var animation_frame := 0

var animation_framerate := '60'
var animation_compression := '18'
var animation_codec := 'libx264'

var frame_length := 100
var frame_digits := 1

var current_project_name := 'New Project'
var current_project_location: String
var current_project_config: ConfigFile


func _ready() -> void:
	DisplayServer.window_set_window_buttons_offset(Vector2i(34, 34))

	ExtensionLoader.load_unpacked_extension('res://base_extensions/core')
	print('Loaded core extension')

	toolbar_reference.add_tool('Manipulate', get_theme_icon('Translate', 'Icons'))

	for packed_user_extension in DirAccess.get_files_at(ExtensionLoader.extensions_path):
		var extension_path := ExtensionLoader.extensions_path.path_join(packed_user_extension)
		match packed_user_extension.get_extension():
			'zip':
				print('Loaded packed user extension: ', packed_user_extension)
				ExtensionLoader.load_packed_extension(extension_path)

	for unpacked_user_extension in DirAccess.get_directories_at(ExtensionLoader.extensions_path):
		print('Loaded unpacked user extension: ', unpacked_user_extension)
		ExtensionLoader.load_unpacked_extension(ExtensionLoader.extensions_path.path_join(unpacked_user_extension))

	components_graph_reference.load_components()
	extensions_manager_window_reference.reload_extensions()

	create_sprite_type_list_window_reference.change_title('Create New Sprite')
	for sprite_type in sprite_types:
		create_sprite_type_list_window_reference.add_item(sprite_type, sprite_type.capitalize(), sprite_types[sprite_type].icon)

	part_temp_directory_location = ProjectSettings.globalize_path('user://part_temp')
	DirAccess.make_dir_recursive_absolute(part_temp_directory_location)
	part_temp_directory = DirAccess.open(part_temp_directory_location)


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

			var component_script = ExtensionLoader.components[component.type].script

			var is_done: bool = component_script.run(
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
		canvas_reference.sub_viewport_reference.get_texture().get_image().save_png(part_temp_directory_location + '/%s.png' % animation_frame)

	animation_frame += 1

	if playing_animation: return
	rendering_animation = false

	if animation_output_path:
		OS.execute('ffmpeg', [
			'-framerate',
			animation_framerate,
			'-i',
			part_temp_directory_location + '/%01d.png',
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


func create_sprite(type: String, sprite_name: String, sprite_uid := str(randi_range(-1000000, 1000000))) -> Node:
	var sprite_type_info: Dictionary = sprite_types[type]

	var new_sprite_item: TreeItem = sprite_tree_reference.create_item(root)

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

	return sprite

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
	if selected_sprite_item:
		selected_sprite_item.set_editable(0, false)

	selected_sprite_item = sprite_tree_reference.get_selected()
	var item_uid: String = selected_sprite_item.get_meta('uid')
	var selected_node: Node2D = canvas_reference.get_sprite(item_uid)

	# Allow name editing separately from this function
	get_tree().create_timer(0.0).timeout.connect(func():
		selected_sprite_item.set_editable(0, true)
	)

	if selected_sprite_uid:
		save_components(selected_sprite_uid)

	selected_sprite_uid = item_uid
	load_components(animation_data[item_uid])

	sprite_control_gizmo_reference.selected_node = selected_node

	inspector_panel_container_reference.remove_all_properties()

	selected_node._load_properties(inspector_panel_container_reference)


func _on_render_button_pressed() -> void:
	render_window.popup_centered()


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
			clear_workspace()
		1:
			save_window.popup_centered()
		2:
			load_window.popup_centered()

func _on_animation_popup_menu_id_pressed(id: int) -> void:
	match id:
		0:
			play_animation()
		1:
			render_window.popup_centered()

func _on_extensions_popup_menu_id_pressed(id: int) -> void:
	match id:
		0:
			extensions_manager_window_reference.popup_centered()


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

			if component.type == 'on_start_component':
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

	for sprite_item in sprite_tree_reference.get_root().get_children():
		var sprite_uid = sprite_item.get_meta('uid')

		var sprite: Node = canvas_reference.get_sprite(sprite_uid)
		var sprite_properties: Dictionary = sprite._save(current_project_location)

		var sprite_animation_data: Dictionary = animation_data[sprite_uid]

		sprites[sprite_uid] = {
			'name': sprite_item.get_text(0),
			'properties': sprite_properties,
			'animation': {
				'components': CurveTools.dictionary_to_json(sprite_animation_data.components),
				'connections': sprite_animation_data.connections
			}
		}

	var encoded_sprites := JSON.stringify(JSON.from_native(sprites))

	var file_access := FileAccess.open(current_project_location + '/res/scenes/main.json', FileAccess.WRITE)
	file_access.store_string(encoded_sprites)


func save_current_project() -> void:
	DirAccess.make_dir_absolute(current_project_location + '/res')
	DirAccess.make_dir_absolute(current_project_location + '/res/scenes')
	DirAccess.make_dir_absolute(current_project_location + '/res/textures')

	current_project_config = ConfigFile.new()
	current_project_config.set_value('project', 'name', current_project_name)
	current_project_config.save(current_project_location + '/project.cfg')

	save_sprites()

func save_new_project(name: String, location: String) -> void:
	current_project_name = name
	current_project_location = location

	DirAccess.make_dir_recursive_absolute(current_project_location)

	DirAccess.make_dir_absolute(current_project_location + '/res')
	DirAccess.make_dir_absolute(current_project_location + '/res/scenes')
	DirAccess.make_dir_absolute(current_project_location + '/res/textures')

	current_project_config = ConfigFile.new()
	current_project_config.set_value('project', 'name', current_project_name)
	current_project_config.save(current_project_location + '/project.cfg')

	save_sprites()

func _on_save_window_save_as(name: String, project_location: String) -> void:
	save_new_project(name, project_location)


func clear_workspace() -> void:
	selected_sprite_item = null
	selected_sprite_uid = ''
	animation_data = {}

	canvas_reference.clear()

	# Remove sprites
	for child in sprite_tree_reference.get_root().get_children():
		child.free()

	# Remove previous components
	for child in components_graph_reference.get_children():
		if child is not GraphNode: continue
		child.queue_free()

	inspector_panel_container_reference.remove_all_properties()

func load_project(project_location: String) -> void:
	clear_workspace()

	current_project_location = project_location

	current_project_config = ConfigFile.new()
	current_project_config.load(project_location + '/project.cfg')

	current_project_name = current_project_config.get_value('project', 'name')

	# Load scene
	var file_access := FileAccess.open(project_location + '/res/scenes/main.json', FileAccess.READ)
	var scene_content: Dictionary = JSON.parse_string(file_access.get_as_text())
	scene_content = JSON.to_native(scene_content)

	# Load sprites
	for sprite_uid in scene_content:
		var sprite_data: Dictionary = scene_content[sprite_uid]

		var created_sprite := create_sprite('costume_sprite', sprite_data.name, sprite_uid)
		created_sprite._load(sprite_data)

		animation_data[sprite_uid] = {
			'components': CurveTools.json_to_dictionary(sprite_data.animation.components),
			'active_components': [],
			'connections': sprite_data.animation.connections
		}

func _on_load_window_load_project(project_name: String, project_location: String) -> void:
	load_project(project_location)


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
	if Input.is_action_just_pressed('project_new'):
		clear_workspace()

	elif Input.is_action_just_pressed('project_save_as'):
		save_window.popup_centered()

	elif Input.is_action_just_pressed('project_save'):
		if current_project_location: save_current_project()
		else: save_window.popup_centered()

	elif Input.is_action_just_pressed('project_load'):
		load_window.popup_centered()

func _on_top_bar_panel_container_gui_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		DisplayServer.window_start_drag()
		return
