extends Sprite2D


var original_image: PackedByteArray
var original_image_extention := 'png'


func _ready() -> void:
	original_image = FileAccess.get_file_as_bytes('res://debug.png')

	var image_for_texture := ImageTools.load_image('res://debug.png')
	texture = ImageTexture.create_from_image(image_for_texture)

func _load_properties(inspector_panel: Node) -> void:
	inspector_panel.add_property('position', position, [], func(new_value: Vector2):
		position = new_value
	)

	inspector_panel.add_property('scale', scale, [], func(new_value: Vector2):
		scale = new_value
	)

	inspector_panel.add_property('rotation', rotation, [], func(new_value: float):
		rotation = new_value
	)


func export(project_path: String) -> void:
	var image_path := project_path + '/res/textures/%s.%s' % [name, original_image_extention]

	var file_access := FileAccess.open(image_path, FileAccess.WRITE)
	file_access.store_buffer(original_image)
