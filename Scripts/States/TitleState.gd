extends Node2D

export var can_input = false

func _ready():
	$AnimationPlayer.play("idle")
	$Button.connect("pressed", $AnimationPlayer, "play", ["start"])

func play_song():
	Conductor.play_song("res://Assets/Music/titleMenu.ogg", 102, 1)

func _input(event):
	if can_input && event is InputEventKey && event.pressed:
		Main.change_scene("res://Scenes/States/MainMenuState.tscn")
	elif event is InputEventKey && event.is_action_pressed("ui_cancel") && Input.is_action_pressed("ui_select"):
		Main.change_scene("res://Scenes/States/MainMenuState.tscn")
