@abstract
class_name Randomizer


const char_soup := '`~!#$^&*()-_=+[{]}|,<>abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'


static func generate_uid(length := 20) -> StringName:
	var uid = ''
	for index in range(length):
		uid += char_soup[randi_range(0, len(char_soup) - 1)]

	return uid
