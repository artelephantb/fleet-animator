extends Sprite2D


func _ready() -> void:
	texture = ImageTexture.create_from_image(ImageTools.load_image('res://icon.svg'))
