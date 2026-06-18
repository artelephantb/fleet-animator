class_name ThirdPartyCreditsWindow
extends Window


var label_reference := Label.new()


func _ready() -> void:
	size = Vector2(800.0, 500.0)

	var background := PanelContainer.new()
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var main_container := VBoxContainer.new()
	main_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(main_container)

	var button_container := HBoxContainer.new()

	var copyright_button := Button.new()
	copyright_button.text = 'Copyright'
	copyright_button.pressed.connect(show_copyright)
	button_container.add_child(copyright_button)

	var licenses_button := Button.new()
	licenses_button.text = 'Licenses'
	licenses_button.pressed.connect(show_licenses)
	button_container.add_child(licenses_button)

	main_container.add_child(button_container)

	var scroll_container := ScrollContainer.new()
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.add_child(label_reference)
	main_container.add_child(scroll_container)

	label_reference.tab_stops = [50.0]

	show_copyright()


func show_copyright() -> void:
	label_reference.text = ''

	for copyright_info in Engine.get_copyright_info():
		label_reference.text += copyright_info.name
		for part in copyright_info.parts:
			for copyright in part.copyright:
				label_reference.text += '\n\t\t© ' + copyright
			label_reference.text += '\n\tLicense: ' + part.license
		label_reference.text += '\n'

func show_licenses() -> void:
	label_reference.text = ''

	var license_info := Engine.get_license_info()
	for license_key in license_info:
		label_reference.text += license_key
		label_reference.text += '\n\t' + license_info[license_key].replace('\n', '\n\t')

		label_reference.text += '\n'
