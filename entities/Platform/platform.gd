class_name Platform extends StaticBody2D

# TODO: remove hardcoded value
@export var width := 500
const height := 30


func get_size() -> Vector2:
	return Vector2(width, height)
		
