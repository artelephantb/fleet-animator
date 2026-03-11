extends GraphNode


@onready var x_position_spin_box_reference := $'XPositionContainer/SpinBox'
@onready var y_position_spin_box_reference := $'YPositionContainer/SpinBox'


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func load_inputs(inputs: Dictionary) -> void:
	if 'position' in inputs:
		x_position_spin_box_reference.value = inputs.position.x
		y_position_spin_box_reference.value = inputs.position.y

func get_inputs() -> Dictionary:
	return {
		'position': Vector2(x_position_spin_box_reference.value, y_position_spin_box_reference.value)
	}
