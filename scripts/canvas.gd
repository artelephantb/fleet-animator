extends SubViewportContainer


@onready var sub_viewport_reference := $'SubViewport'


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func create_texture_sprite(uid: int, texture: Texture2D, start_position := Vector2(0.0, 0.0)) -> Sprite2D:
	var new_sprite := Sprite2D.new()

	new_sprite.name = str(uid)
	new_sprite.texture = texture
	new_sprite.position = start_position

	sub_viewport_reference.add_child(new_sprite)

	return new_sprite
