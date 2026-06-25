class_name ComponentPath


var current_component_data: Dictionary
var current_component_uid: StringName
var layer_uid: StringName

var variables := {}


func set_variable(name: StringName, value) -> void:
	variables[name] = value

func get_variable(name: StringName):
	return variables[name]

func get_or_add_var(name: StringName, default = null):
	return variables.get_or_add(name, default)


func finished_compnent() -> void:
	print('Finished Component')
