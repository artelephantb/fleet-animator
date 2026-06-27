class_name LineEditProperty
extends HBoxContainer


var text_box_reference := LineEdit.new()
var default := ''


func _init(name: StringName, placeholder := '') -> void:
	self.name = name
	text_box_reference.placeholder_text = placeholder

func _ready() -> void:
	var name_label := Label.new()
	name_label.text = name.capitalize()
	add_child(name_label)

	add_child(text_box_reference)


func set_value(value: String) -> void:
	text_box_reference.text = value

func get_value() -> String:
	return text_box_reference.text
