extends Sprite

export var speed = 0

func _physics_process(delta):
	position.y += speed
	if position.y > 0:
		position.y = -1350
