extends Tree


@export var in_between_drop_margin = 20.0


func _get_drag_data(at_position: Vector2) -> Variant:
	var item := get_item_at_position(at_position)
	if !item: return null

	var preview_label = Label.new()
	preview_label.text = item.get_text(0)
	set_drag_preview(preview_label)

	drop_mode_flags = 2

	return get_selected()

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var item := get_item_at_position(at_position)
	if !item: return false

	var item_area_rect := get_item_area_rect(item)
	var offset_position := at_position - item_area_rect.position

	var can_drop_between_top: bool = offset_position.y < in_between_drop_margin
	var can_drop_between_bottom: bool = offset_position.y > item_area_rect.size.y - in_between_drop_margin

	if can_drop_between_top or can_drop_between_bottom: return true

	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var item = get_item_at_position(at_position)
	if !item: return

	var item_area_rect := get_item_area_rect(item)
	var offset_position := at_position - item_area_rect.position

	var can_drop_between_top: bool = offset_position.y < in_between_drop_margin
	var can_drop_between_bottom: bool = offset_position.y > item_area_rect.size.y - in_between_drop_margin

	if can_drop_between_top:
		data.move_before(item)
		return

	if can_drop_between_bottom:
		data.move_after(item)
		return
