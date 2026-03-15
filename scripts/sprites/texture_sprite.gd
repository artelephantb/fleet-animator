extends Sprite2D


var original_image: PackedByteArray
var original_image_extention := 'png'


func _ready() -> void:
	original_image = FileAccess.get_file_as_bytes('res://debug.png')

	var image_for_texture := ImageTools.load_image('res://debug.png')
	texture = ImageTexture.create_from_image(image_for_texture)


func export(project_path: String) -> void:
	var image_path := project_path + '/res/textures/%s.%s' % [name, original_image_extention]

	var file_access := FileAccess.open(image_path, FileAccess.WRITE)
	file_access.store_buffer(original_image)
