extends Sprite2D


var original_image: PackedByteArray
var original_image_extention := 'svg'


func _ready() -> void:
	original_image = FileAccess.get_file_as_bytes('res://icon.svg')

	var image_for_texture := ImageTools.load_image('res://icon.svg')
	texture = ImageTexture.create_from_image(image_for_texture)


func export(project_path: String) -> void:
	var image_path := project_path + '/res/textures/%s.%s' % [name, original_image_extention]

	var file_access := FileAccess.open(image_path, FileAccess.WRITE)
	file_access.store_buffer(original_image)
