extends Node2D

onready var play_state = get_parent().get_parent().get_parent()

enum Note {Left, Down, Up, Right}
var next_notes = []

func _ready():
	queue_free()

func _physics_process(delta):
	next_notes = []
	for note in play_state.get_node("HUD/HudElements/PlayerStrumLine/Notes").get_children():
		if note.position.y < next_notes[0].position.y:
			next_notes[0] = note
		elif note.position.y == next_notes[0].position.y:
			next_notes[1] = next_notes[0]
			next_notes[0] = note
