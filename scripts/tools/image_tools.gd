extends Node


var image_cache := {}


func load_image(image_path: String) -> Image:
	if image_path in image_cache: return image_cache[image_path]

	var image := Image.load_from_file(image_path)
	if image == null:
		image = Image.load_from_file('res://icon.svg')

	image_cache[image_path] = image

	return image

func load_image_from_packed_byte_array(packed_image: PackedByteArray) -> Image:
	var image := Image.new()
	image.load_png_from_buffer(packed_image)

	return image
