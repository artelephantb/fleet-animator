class_name CurveEditorProperty
extends VBoxContainer


var curve_editor := CurveEditor.new()

var default := Curve.new()


func _ready() -> void:
	var name_label := Label.new()
	name_label.text = name.capitalize()
	add_child(name_label)

	add_child(curve_editor)

	default.add_point(Vector2(0.0, 0.0))
	default.add_point(Vector2(1.0, 1.0))

func set_curve(curve: Curve) -> void:
	curve_editor.set_curve(curve)

func get_curve() -> Curve:
	return curve_editor.get_data()
