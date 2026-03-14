@tool
extends VBoxContainer

signal value_changed(new_value: Vector2)


@onready var x_spin_box := $'XHBoxContainer/SpinBox'
@onready var y_spin_box := $'YHBoxContainer/SpinBox'

@export var value := Vector2(0, 0):
	set(new_value):
		if x_spin_box: x_spin_box.value = new_value.x
		if y_spin_box: y_spin_box.value = new_value.y

		value = new_value


func _ready() -> void:
	x_spin_box.value = value.x
	y_spin_box.value = value.y


func _on_x_spin_box_value_changed(new_value: float) -> void:
	value.x = new_value
	value_changed.emit(value)

func _on_y_spin_box_value_changed(new_value: float) -> void:
	value.y = new_value
	value_changed.emit(value)
