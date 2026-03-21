extends Window


@onready var item_list_reference := $'MarginContainer/VBoxContainer/InstalledItemList'

var items := []


func _on_close_requested() -> void:
	hide()


func reload_extensions() -> void:
	remove_all_items()

	for extension_id in ExtensionLoader.extensions:
		var extension_data: Dictionary = ExtensionLoader.extensions[extension_id]
		add_item(extension_id, extension_data.name)


func change_title(new_title: String) -> void:
	title = new_title


func add_item(id: String, text: String, icon: Texture2D = null, selectable := true) -> void:
	items.append(id)
	item_list_reference.add_item(text, icon, selectable)

func remove_item(id: String) -> void:
	item_list_reference.remove_item(items.find(id))
	items.erase(id)

func remove_all_items() -> void:
	item_list_reference.clear()
	items.clear()


func _on_about_to_popup() -> void:
	item_list_reference.grab_focus(true)


func _on_open_in_file_manager_button_pressed() -> void:
	var selected_items: PackedInt32Array = item_list_reference.get_selected_items()
	if not selected_items: return

	var single_selected_item: String = items[selected_items[0]]
	OS.shell_show_in_file_manager(ExtensionLoader.extensions_path.path_join(single_selected_item))
