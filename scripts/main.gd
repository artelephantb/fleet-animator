extends Control


@onready var sprite_tree_reference := $'HSplitContainer/SpriteTree'

@onready var sprite_icon := preload('res://icons/sprite.svg')


func _ready() -> void:
	var root: TreeItem = sprite_tree_reference.create_item()
	root.set_text(0, 'Root')

	for index in 10:
		var new_sprite: TreeItem = sprite_tree_reference.create_item(root)
		new_sprite.set_text(0, str(randi()))
		new_sprite.set_icon(0, sprite_icon)

func _process(delta: float) -> void:
	pass
