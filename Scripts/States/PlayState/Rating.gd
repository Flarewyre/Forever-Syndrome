extends Node2D

var vsp = -150
var gravity = 900

var combo = 0
var offset = 0
var rating = 0

var numberTexture = preload("res://Assets/Sprites/UI/combo.png")
var numberVsps = []

var text = [
	"MISS",
	"SHIT",
	"BAD",
	"GOOD",
	"SICK!!"
]

func _ready():
	$Combo.text = str(combo) + " COMBO"
	
	$Rating/Label.text = str(round(offset)) + "ms"
	$Rating.text = text[rating + 1]

func _process(delta):
	position.y += vsp * delta
	vsp += gravity * delta
	
	if (vsp > 256):
		modulate.a -= 6 * delta
		
	if (modulate.a <= 0):
		queue_free()
	
	move_numbers(delta)
	
func move_numbers(delta):
	var index = 0
	for child in get_children():
		if (index == 0):
			index += 1
			continue
		
		#child.position += numberVsps[index-1] * delta
		#numberVsps[index-1].y += gravity * delta
		
		index += 1

func create_numbers():
	var comboLen = len(str(combo))
	var trueLength = comboLen
	
	var sep = -40
	if (Settings.hudRatings):
		sep = -60
	
	if (comboLen < 3 && combo >= 0):
		comboLen = 3
	for i in range(comboLen):
		var pos = Vector2(sep * i, 0)
		var number = str(combo).substr(trueLength-(i+1), 1)
		create_number(pos, number)

func create_number(pos, number):
	pass
