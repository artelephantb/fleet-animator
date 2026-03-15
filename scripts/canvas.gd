extends SubViewportContainer


@onready var sub_viewport_reference := $'SubViewport'


func create_texture_sprite(sprite_uid: String, texture: Texture2D, start_position := Vector2(0.0, 0.0)) -> Sprite2D:
	var new_sprite := Sprite2D.new()

	new_sprite.name = sprite_uid
	new_sprite.texture = texture
	new_sprite.position = start_position

	sub_viewport_reference.add_child(new_sprite)

	return new_sprite

func get_sprite(sprite_uid: String) -> Node:
	return sub_viewport_reference.get_node(sprite_uid)
