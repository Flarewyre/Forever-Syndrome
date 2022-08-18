extends TextureRect

var velocity : float

export(float) var gravity
export(float) var bounce_power

func _ready():
	rect_position.y = -128

func _physics_process(delta):
	velocity += gravity
	rect_position.y += velocity * delta
	
	if rect_position.y > 32:
		rect_position.y = 32
		velocity = -bounce_power * rand_range(0.6, 1.0)
