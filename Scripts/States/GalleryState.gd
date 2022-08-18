extends Node2D

export(Array, Resource) var entries

var portrait
var selection := 0

func _ready():
	if Conductor.MusicStream.stream.resource_path != "res://Assets/Music/galleryMenu.ogg":
		Conductor.play_song("res://Assets/Music/galleryMenu.ogg", 102, 1)
	$Buttons/HBoxContainer/Exit.grab_focus()
	
	$Buttons/HBoxContainer/Prev.connect("button_down", self, "change_selection", [-1])
	$Buttons/HBoxContainer/Next.connect("button_down", self, "change_selection", [1])
	$Buttons/HBoxContainer/Exit.connect("button_down", self, "exit")
	get_viewport().connect("gui_focus_changed", self, "on_focus_changed")
	$Music/MusicStream.volume_db = 2
	
	change_selection(0)

func change_selection(amount):
	selection = wrapi(selection + amount, 0, entries.size())
	if amount != 0:
		$Sounds/ConfirmStream.play()
	
	if is_instance_valid(portrait):
		portrait.queue_free()
	portrait = entries[selection].portrait.instance()
	add_child(portrait)
	
	$Info/Name.text = entries[selection].name.to_upper()
	$Info/Description.text = entries[selection].description
	$Info/Origin.text = "From: " + entries[selection].origin

func exit():
	$Sounds/CancelStream.play()
	Main.change_scene("res://Scenes/States/MainMenuState.tscn")

func on_focus_changed(control):
	$Sounds/MoveStream.play()
