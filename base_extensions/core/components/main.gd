static var id = 'main'

static var component_ids: PackedStringArray = [
	'recieve_signal',
	'change_position',
	'change_scale',
	'change_rotation',
	'wait_frames'
]

static var component_names := {
	'recieve_signal': 'Recieve Signal',
	'change_position': 'Change Position',
	'change_scale': 'Change Scale',
	'change_rotation': 'Change Rotation',
	'wait_frames': 'Wait Frames'
}

var component_bindings := {
	'recieve_signal': recieve_signal,
	'change_position': change_position,
	'change_scale': change_scale,
	'change_rotation': change_rotation,
	'wait_frames': wait_frames
}


func _init() -> void:
	pass


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
