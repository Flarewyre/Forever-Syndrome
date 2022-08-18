extends Node2D

var type = 0
var animFrame = 0
var selected = false
var text = ""

func _ready():
	$Label.text = text

func _process(delta):
	modulate = Color("ffcc00") if !selected else Color.white
	scale.x = lerp(scale.x, 0.8 if !selected else 0.95, delta * 10)
	scale.y = scale.x
