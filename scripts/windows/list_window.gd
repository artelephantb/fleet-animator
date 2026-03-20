extends Window

signal single_item_selected(uid: String)
signal multiple_items_selected(item_uids: Array[String])


@onready var item_list_reference := $'MarginContainer/VBoxContainer/ItemList'

var items := []


func _on_close_requested() -> void:
	hide()


func change_title(new_title: String) -> void:
	title = new_title


func add_item(uid: String, text: String, icon: Texture2D = null, selectable := true) -> void:
	items.append(uid)
	item_list_reference.add_item(text, icon, selectable)

func remove_item(uid: String) -> void:
	item_list_reference.remove_item(items.find(uid))
	items.erase(uid)

func remove_all_items() -> void:
	item_list_reference.clear()


func _on_about_to_popup() -> void:
	item_list_reference.grab_focus(true)


func _on_select_button_pressed() -> void:
	var selected_items_indexes: Array = item_list_reference.get_selected_items()
	if len(selected_items_indexes) == 1:
		single_item_selected.emit(items[selected_items_indexes[0]])
	else:
		var selected_items := []
		for item_index in selected_items_indexes:
			selected_items.append(items[item_index])

		multiple_items_selected.emit(selected_items)

	hide()

func _on_item_list_item_activated(index: int) -> void:
	single_item_selected.emit(items[index])
	hide()
