static var id = 'main'

static var component_ids: PackedStringArray = [
	'animation_started',
	'recieve_signal',
	'change_position',
	'change_scale',
	'change_rotation',
	'wait_frames'
]

static var component_names := {
	'animation_started': 'On Animation Started',
	'recieve_signal': 'On Receiving Signal',
	'change_position': 'Change Position',
	'change_scale': 'Change Scale',
	'change_rotation': 'Change Rotation',
	'wait_frames': 'Wait Frames'
}

var component_looks := {
	'animation_started': looks_animation_started,
	'recieve_signal': looks_recieve_signal,
	'change_position': looks_change_position,
	'change_scale': looks_change_scale,
	'change_rotation': looks_change_rotation,
	'wait_frames': looks_wait_frames
}

var component_bindings := {
	'animation_started': animation_started,
	'recieve_signal': recieve_signal,
	'change_position': change_position,
	'change_scale': change_scale,
	'change_rotation': change_rotation,
	'wait_frames': wait_frames
}


func looks_animation_started(component: GraphComponent):
	component.title = 'On Animation Started'
	component.add_runtime_connection(false)

func looks_recieve_signal(component: GraphComponent):
	component.title = 'On Receiving Signal'
	component.add_runtime_connection(false)

func looks_change_position(component: GraphComponent):
	component.title = 'Change Position'
	component.add_runtime_connection()
	component.add_vector2_property('Position')
	component.add_float_property('AcrossFrames', 100.0, 1.0, 10000.0, false)
	component.add_curve_editor_property('Curve')

func looks_change_scale(component: GraphComponent):
	component.title = 'Change Scale'
	component.add_runtime_connection()
	component.add_vector2_property('Scale', Vector2(1.0, 1.0))
	component.add_float_property('AcrossFrames', 100.0, 1.0, 10000.0, false)
	component.add_curve_editor_property('Curve')

func looks_change_rotation(component: GraphComponent):
	component.title = 'Change Rotation'
	component.add_runtime_connection()

func looks_wait_frames(component: GraphComponent):
	component.title = 'Wait Frames'
	component.add_runtime_connection()
	component.add_float_property('Frames', 60.0, 1.0, 10000.0, false)


func animation_started(path: ComponentPath):
	path.finished_component()

func recieve_signal(path: ComponentPath):
	pass

func change_position(path: ComponentPath):
	var x: float = path.variables.get_or_add('x', 0.0)
	var og_pos: Vector2 = path.variables.get_or_add('og_pos', path.layer_reference.position)

	x += 1.0 / path.component_data.inputs.AcrossFrames
	path.variables['x'] = x
	var y: float = path.component_data.inputs.Curve.sample(x)

	path.layer_reference.position = og_pos.lerp(path.component_data.inputs.Position, y)

	if x >= path.component_data.inputs.Curve.sample(1.0):
		path.finished_component()

func change_scale(path: ComponentPath):
	var x: float = path.variables.get_or_add('x', 0.0)
	var og_scale: Vector2 = path.variables.get_or_add('og_scale', path.layer_reference.scale)

	x += 1 / path.component_data.inputs.AcrossFrames
	path.variables['x'] = x
	var y: float = path.component_data.inputs.Curve.sample(x)

	path.layer_reference.scale = og_scale.lerp(path.component_data.inputs.Scale, y)

	if x >= path.component_data.inputs.Curve.sample(1.0):
		path.finished_component()

func change_rotation(path: ComponentPath):
	pass

func wait_frames(path: ComponentPath):
	var current: int = path.variables.get_or_add('current', path.component_data.inputs.Frames + 1)
	current -= 1
	path.variables['current'] = current

	if current <= 0: path.finished_component()
