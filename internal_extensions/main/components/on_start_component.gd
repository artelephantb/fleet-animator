extends GraphNode


static var component_name := 'On Start Event'
static var component_description := 'Runs the following connected components when the animation is started.'


func _ready() -> void:
	title = 'On Start'

	set_slot(0, false, 0, Color(), true, 0, Color(0.0, 1.0, 0.0))

	var label := Label.new()
	add_child(label)


func load_inputs(inputs: Dictionary) -> void:
	pass

func get_inputs() -> Dictionary:
	return {}


static func run(component_uid: String, sprite: Node, inputs: Dictionary, active_variables: Dictionary) -> bool:
	return true
