extends Node


var image_cache := {}


func load_image(image_path: String) -> Image:
	if image_path in image_cache: return image_cache[image_path]

	var image := Image.load_from_file(image_path)
	if image == null:
		image = Image.load_from_file('res://icon.svg')

	image_cache[image_path] = image

	return image

func get_image_from_packed_byte_array_or_null_image(packed_image: PackedByteArray) -> Image:
	if packed_image == null:
		packed_image = FileAccess.get_file_as_bytes('res://icon.svg')

	var image := Image.new()
	image.load_png_from_buffer(packed_image)

	return image
