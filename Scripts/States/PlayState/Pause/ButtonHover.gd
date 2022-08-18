extends TextureButton

func _physics_process(delta):
	var target_scale = Vector2(1.5, 1.5) if !is_hovered() else Vector2(1.65, 1.65)
	rect_scale = lerp(rect_scale, target_scale, delta * 8)
