extends Control


@onready var sprite_tree_reference := $'HSplitContainer/PanelContainer/MarginContainer/VBoxContainer/SpriteTree'
@onready var canvas_reference := $'HSplitContainer/Control/Canvas'

@onready var gizmos_reference := $'HSplitContainer/Control/SpritePositionGizmo'

@onready var sprite_icon_image := preload('res://icons/sprite.svg')
@onready var missing_texture := preload('res://icon.svg')

@onready var root: TreeItem = sprite_tree_reference.create_item()


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func create_sprite(sprite_name: String, sprite_icon := sprite_icon_image) -> TreeItem:
	var new_sprite: TreeItem = sprite_tree_reference.create_item(root)
	var sprite_uid := randi_range(-1000000, 1000000)

	new_sprite.set_text(0, sprite_name)
	new_sprite.set_icon(0, sprite_icon)

	new_sprite.set_meta('uid', sprite_uid)

	canvas_reference.create_texture_sprite(sprite_uid, missing_texture)

	return new_sprite

func _on_create_sprite_button_pressed() -> void:
	create_sprite('New Sprite')

func _on_sprite_tree_item_selected() -> void:
	var selected_item: TreeItem = sprite_tree_reference.get_selected()
	var item_uid := str(selected_item.get_meta('uid'))
	var selected_node: Node2D = canvas_reference.sub_viewport_reference.get_node(item_uid)

	gizmos_reference.selected_node = selected_node
