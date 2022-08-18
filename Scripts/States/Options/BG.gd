extends TextureRect

func _physics_process(delta):
	rect_position += Vector2(1, 1)
	if rect_position.y >= 0:
		rect_position = Vector2(-192, -192)
