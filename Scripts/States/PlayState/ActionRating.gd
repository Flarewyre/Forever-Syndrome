extends Node2D

var vsp = -150
var gravity = 900

var combo = 0
var offset = 0
var rating = 0

var numberTexture = preload("res://Assets/Sprites/UI/combo.png")
var numberVsps = []

var text = [
	0,
	1,
	2,
	3
]

func _ready():
	$Sprite.frame = rating

func _process(delta):
	position.y += vsp * delta
	vsp += gravity * delta
	
	if (vsp > 256):
		modulate.a -= 6 * delta
		
	if (modulate.a <= 0):
		queue_free()
	
func move_numbers(delta):
	pass

func create_numbers():
	pass

func create_number(pos, number):
	pass
