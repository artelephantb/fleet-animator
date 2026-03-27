extends PanelContainer


@onready var tools_container := $'MarginContainer/ToolsContainer'


func add_tool(text := '', icon = null) -> void:
	var tool_button := Button.new()
	tool_button.toggle_mode = true

	tool_button.text = text
	tool_button.icon = icon

	tool_button.connect('toggled', _on_tool_toggled.bind(tool_button))

	if tools_container.get_child_count() == 0:
		tool_button.button_pressed = true

	tools_container.add_child(tool_button)


func _on_tool_toggled(toggled_on: bool, tool_node: Button) -> void:
	if !toggled_on:
		tool_node.set_block_signals(true)
		tool_node.button_pressed = true
		tool_node.set_block_signals(false)

		return

	for child in tools_container.get_children():
		if child == tool_node: continue

		child.set_block_signals(true)
		child.button_pressed = false
		child.set_block_signals(false)
