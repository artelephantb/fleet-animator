extends Node


var components := {}


func get_extension_info(path: String) -> Dictionary:
	var config_location := path.path_join('extension.cfg')

	var config_file := ConfigFile.new()
	config_file.load(config_location)

	return {
		'id': config_file.get_value('extension', 'id'),
		'name': config_file.get_value('extension', 'name'),
		'description': config_file.get_value('extension', 'description')
	}

func load_extension(path: String) -> void:
	var config_path := path.path_join('extension.cfg')

	var config_file := ConfigFile.new()
	config_file.load(config_path)

	var extension_id: String = config_file.get_value('extension', 'id')

	var component_scripts := DirAccess.get_files_at(path.path_join('components'))
	for script in component_scripts:
		if script.get_extension() != 'gd': continue

		var script_path := path.path_join('components/' + script)
		var loaded_script = load(script_path)

		var component_id := script.get_basename()

		components[component_id] = {
			'name': loaded_script.component_name,
			'description': loaded_script.component_description,
			'script': loaded_script
		}
