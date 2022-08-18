extends Sprite


func _physics_process(delta):
	position.x -= 2
	if position.x <= (-256 * 2.5):
		position.x = 0
