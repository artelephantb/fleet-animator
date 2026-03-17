extends Sprite2D


var original_image: PackedByteArray
var original_image_extention: String


func _ready() -> void:
	if !original_image: change_texture_from_file('')

func _load_properties(inspector_panel: Node) -> void:
	inspector_panel.add_file_button_property('texture', 'Replace', [], change_texture_from_file)

	inspector_panel.add_property('position', position, [], func(new_value: Vector2):
		position = new_value
	)

	inspector_panel.add_property('scale', scale, [], func(new_value: Vector2):
		scale = new_value
	)

	inspector_panel.add_property('rotation', rotation, [], func(new_value: float):
		rotation = new_value
	)


func _save(project_path: String) -> Dictionary:
	var image_path := project_path + '/res/textures/%s.%s' % [name, original_image_extention]

	var file_access := FileAccess.open(image_path, FileAccess.WRITE)
	file_access.store_buffer(original_image)

	return {
		'texture_path': image_path,
		'position': position,
		'scale': scale,
		'rotation': rotation
	}

func _load(sprite_data: Dictionary) -> void:
	var sprite_properties: Dictionary = sprite_data.properties

	change_texture_from_file(sprite_properties.texture_path)
	position = sprite_properties.position
	scale = sprite_properties.scale
	rotation = sprite_properties.rotation


func change_texture_from_file(texture_location: String) -> void:
	original_image = FileAccess.get_file_as_bytes(texture_location)

	var image_for_texture := ImageTools.load_image(texture_location)
	texture = ImageTexture.create_from_image(image_for_texture)

	original_image_extention = texture_location.get_extension()
