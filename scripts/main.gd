extends Control


@onready var sprite_tree_reference := $'HSplitContainer/PanelContainer/MarginContainer/VBoxContainer/SpriteTree'

@onready var sprite_icon_image := preload('res://icons/sprite.svg')

@onready var root: TreeItem = sprite_tree_reference.create_item()


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func create_sprite(sprite_name: String, sprite_icon=sprite_icon_image) -> TreeItem:
	var new_sprite: TreeItem = sprite_tree_reference.create_item(root)

	new_sprite.set_text(0, sprite_name)
	new_sprite.set_icon(0, sprite_icon)

	return new_sprite

func _on_create_sprite_button_pressed() -> void:
	create_sprite('New Sprite')
