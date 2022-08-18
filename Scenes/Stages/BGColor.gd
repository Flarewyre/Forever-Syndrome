extends TextureRect

export var is_cycling = false
var hue = 0.0

func _physics_process(delta):
	if is_cycling:
		modulate = lerp(modulate, Color().from_hsv(hue / 255, 1, 1), delta)
		hue = wrapf(hue + 1, 0, 255)
	else:
		modulate = lerp(modulate, Color.white, delta)
