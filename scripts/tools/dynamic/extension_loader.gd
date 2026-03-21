extends Node


var extensions := {}
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

	extensions[config_file.get_value('extension', 'id')] = {
		'name': config_file.get_value('extension', 'name'),
		'description': config_file.get_value('extension', 'description')
	}

	var components_list = config_file.get_value('requirements', 'components')
	if components_list != null:
		for script in components_list:
			var script_path := path.path_join(script)
			var loaded_script = load(script_path)

			var component_id: String = script_path.get_file().get_basename()

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

	extensions[config_file.get_value('extension', 'id')] = {
		'name': config_file.get_value('extension', 'name'),
		'description': config_file.get_value('extension', 'description')
	}

	var components_list = config_file.get_value('requirements', 'components')
	if components_list != null:
		for script in components_list:
			var temp_script_file := FileAccess.create_temp(FileAccess.WRITE, '', 'gd')
			temp_script_file.store_buffer(zip_reader.read_file(script))
			temp_script_file.close()

			var script_path := temp_script_file.get_path()
			var loaded_script = load(script_path)

			var component_id: String = script.get_file().get_basename()

			components[component_id] = {
				'name': loaded_script.component_name,
				'description': loaded_script.component_description,
				'script': loaded_script
			}
