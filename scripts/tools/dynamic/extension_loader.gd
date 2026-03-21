extends Node


var components := {}

var extensions_path := ProjectSettings.globalize_path('user://extensions')


func get_extension_info(path: String) -> Dictionary:
	var config_location := path.path_join('extension.cfg')

	var config_file := ConfigFile.new()
	config_file.load(config_location)

	return {
		'id': config_file.get_value('extension', 'id'),
		'name': config_file.get_value('extension', 'name'),
		'description': config_file.get_value('extension', 'description')
	}

func load_unpacked_extension(path: String) -> void:
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


func load_packed_extension(path: String) -> void:
	var zip_reader := ZIPReader.new()
	zip_reader.open(path)

	var temp_config_file := FileAccess.create_temp(FileAccess.WRITE)
	temp_config_file.store_buffer(zip_reader.read_file('extension.cfg'))
	temp_config_file.close()

	var config_path := temp_config_file.get_path()

	var config_file := ConfigFile.new()
	config_file.load(config_path)

	var extension_id: String = config_file.get_value('extension', 'id')

	var files := zip_reader.get_files()
	for file_path in files:
		if !file_path.begins_with('components/'): continue
		if file_path.get_extension() != 'gd': continue

		var temp_script_file := FileAccess.create_temp(FileAccess.WRITE, '', 'gd')
		temp_script_file.store_buffer(zip_reader.read_file(file_path))
		temp_script_file.close()

		var script_path := temp_script_file.get_path()
		var loaded_script = load(script_path)

		var component_id := file_path.get_file().get_basename()

		components[component_id] = {
			'name': loaded_script.component_name,
			'description': loaded_script.component_description,
			'script': loaded_script
		}
