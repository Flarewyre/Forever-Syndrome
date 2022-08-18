extends TileMap

export (float) var speed = 1 

func _physics_process(delta):
	position.x += delta * speed
	if position.x > 32 * scale.x:
		position.x = 0
