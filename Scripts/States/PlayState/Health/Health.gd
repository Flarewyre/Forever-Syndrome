class_name Health
extends Node2D

export(float) var health = 0
var oldHealth = health

func setup_health():
	pass

func note_hit(note, timing):
	pass

func note_miss(note_type, passed):
	pass

func health_bar_process(delta):
	pass
