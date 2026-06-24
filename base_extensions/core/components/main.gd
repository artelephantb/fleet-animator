static var id = 'main'

static var component_ids: PackedStringArray = [
	'recieve_signal',
	'change_position',
	'change_scale',
	'change_rotation',
	'wait_frames'
]

static var component_names := {
	'recieve_signal': 'On Receiving Signal',
	'change_position': 'Change Position',
	'change_scale': 'Change Scale',
	'change_rotation': 'Change Rotation',
	'wait_frames': 'Wait Frames'
}

var component_looks := {
	'recieve_signal': looks_recieve_signal,
	'change_position': looks_change_position,
	'change_scale': looks_change_scale,
	'change_rotation': looks_change_rotation,
	'wait_frames': looks_wait_frames
}

var component_bindings := {
	'recieve_signal': recieve_signal,
	'change_position': change_position,
	'change_scale': change_scale,
	'change_rotation': change_rotation,
	'wait_frames': wait_frames
}


func looks_recieve_signal(component: GraphComponent):
	component.title = 'On Receiving Signal'

func looks_change_position(component: GraphComponent):
	component.title = 'Change Position'
	component.add_vector2_property('Position')
	component.add_label('Across Frames')
	component.add_float_property('AcrossFrames', 0.0)

func looks_change_scale(component: GraphComponent):
	component.title = 'Change Scale'

func looks_change_rotation(component: GraphComponent):
	component.title = 'Change Rotation'

func looks_wait_frames(component: GraphComponent):
	component.title = 'Wait Frames'
	component.add_label('Frames')
	component.add_float_property('Frames', 60.0)


func recieve_signal():
	pass

func change_position():
	pass

func change_scale():
	pass

func change_rotation():
	pass

func wait_frames():
	pass
