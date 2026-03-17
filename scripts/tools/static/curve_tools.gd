class_name CurveTools


static func curve_to_array(curve: Curve) -> Array:
	var points := []

	for point_index in curve.point_count:
		var point = {
			'position': curve.get_point_position(point_index),
			'left_tangent': curve.get_point_left_tangent(point_index),
			'right_tangent': curve.get_point_right_tangent(point_index),
			'left_mode': curve.get_point_left_mode(point_index),
			'right_mode': curve.get_point_right_mode(point_index)
		}

		points.append(point)

	return points

static func array_to_curve(array: Array) -> Curve:
	var curve := Curve.new()

	for point in array:
		curve.add_point(
			point.position,
			point.left_tangent,
			point.right_tangent,
			point.left_mode,
			point.right_mode
		)

	return curve


static func dictionary_to_json(dictionary: Dictionary) -> Dictionary:
	var json := {}

	for key in dictionary:
		var value: Variant = dictionary[key]

		match type_string(typeof(value)):
			'Object':
				if value is Curve:
					json[key] = {
						'Type::Curve': curve_to_array(value)
					}
			'Dictionary':
				json[key] = dictionary_to_json(value)
			_:
				json[key] = value

	return json

static func json_to_dictionary(json: Dictionary) -> Dictionary:
	var dictionary := {}

	for key in json:
		var value: Variant = json[key]

		match type_string(typeof(value)):
			'Dictionary':
				if 'Type::Curve' in value:
					dictionary[key] = array_to_curve(value['Type::Curve'])
				else:
					dictionary[key] = json_to_dictionary(value)
			_:
				dictionary[key] = value

	return dictionary
