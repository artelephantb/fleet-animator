extends GraphNode


static var component_name := 'Flip Horizontally'
static var component_description := 'Flips the sprite horizontally.'


func _ready() -> void:
	title = component_name

	set_slot(0, true, 0, Color.GREEN, true, 0, Color.GREEN)

	var label := Label.new()
	add_child(label)


func load_inputs(inputs: Dictionary) -> void:
	pass

func get_inputs() -> Dictionary:
	return {}


static func run(component_uid: String, sprite: Node, inputs: Dictionary, active_variables: Dictionary) -> bool:
	sprite.scale.x = -sprite.scale.x
	return true
