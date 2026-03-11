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

var playing_animation := false

var part_temp_directory: DirAccess
var part_temp_directory_location: String

var rendering_animation := false
var animation_output_path: String

var animation_frame := 0

var animation_framerate := '24'
var animation_compression := '18'
var animation_codec := 'libx264'


func _ready():
	part_temp_directory_location = ProjectSettings.globalize_path('user://part_temp')
	DirAccess.make_dir_recursive_absolute(part_temp_directory_location)
	part_temp_directory = DirAccess.open(part_temp_directory_location)


func update_play_animation() -> void:
	pass

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
	var sprite_uid := randi_range(-1000000, 1000000)

	new_sprite_item.set_editable(0, true)

	new_sprite_item.set_text(0, sprite_name)
	new_sprite_item.set_icon(0, sprite_icon)

	new_sprite_item.set_meta('uid', sprite_uid)

	canvas_reference.create_texture_sprite(sprite_uid, missing_texture)

	return new_sprite_item

func _on_create_sprite_button_pressed() -> void:
	create_sprite('New Sprite')

func _on_sprite_tree_item_selected() -> void:
	var selected_item: TreeItem = sprite_tree_reference.get_selected()
	var item_uid := str(selected_item.get_meta('uid'))
	var selected_node: Node2D = canvas_reference.sub_viewport_reference.get_node(item_uid)

	sprite_control_gizmo_reference.selected_node = selected_node


func _on_render_button_pressed() -> void:
	render_popup.popup_centered()


func play_animation() -> void:
	playing_animation = true
	print(components_graph_reference.get_connection_list())

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
