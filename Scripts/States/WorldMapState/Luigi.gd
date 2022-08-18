extends AnimatedSprite

export (float, 1, 1000) var frequencyX
export (float, 1000) var amplitudeX

export (float, 1, 1000) var frequencyY
export (float, 1000) var amplitudeY

var initial_pos : Vector2
var time : float

func _physics_process(delta):
	time += delta
	var timeY = time + 3
	
	var movementX = cos(time*frequencyX) * amplitudeX
	position.x = movementX * delta

	var movementY = cos(timeY*frequencyY) * amplitudeY
	position.y = (movementY * delta) - 15
