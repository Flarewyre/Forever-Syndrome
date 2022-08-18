extends Node2D

export(Array, String) var descriptions

const BUTTON_SCENE = preload("res://Scenes/States/MainMenu/MainMenuButton.tscn")
# var options = {"story": 3, "freeplay": 1, "options": 2, "donate": 0}
var options = {"mario forever": 3}

var optionsOffset = Vector2(50, 220)

var selected = 0
var choseOption = false
var remixUnlocked = false

func _ready():
	remixUnlocked = Conductor.load_score("Forever-Syndrome") > 0
	if remixUnlocked:
		options["remix"] = 1
	else:
		descriptions = descriptions.duplicate()
		descriptions.remove(1)
	options["options"] = 2
	
	createMenuObjects()
	
	if Conductor.MusicStream.stream.resource_path != "res://Assets/Music/freakyMenu.ogg":
		Conductor.play_song("res://Assets/Music/freakyMenu.ogg", 102, 1)

func _process(_delta):
	if (choseOption):
		return
	
	var optionsSize = options.keys().size()
	var offset = selected - (optionsSize / 2)
	
	var move = int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
	
	if (move != 0):
		get_node("Sounds/MoveStream").play()
	
	if (selected + move < 0):
		move = 0
		selected = options.size() - 1
	if (selected + move > options.size() - 1):
		move = 0
		selected = 0
	
	selected += move
	$Bar/Description.text = descriptions[selected]

	if selected == 0 || selected == 1:
		var songName = "Forever-Syndrome" if selected == 0 else 'Forever-Syndrome-Remix'
		var score = Conductor.load_score(songName)
		var fcType = Conductor.load_fc(songName)

		var suffix = ""
		match (fcType):
			1:
				suffix = " (FC)"
			2:
				suffix = " (GFC)"
			3:
				suffix = " (SFC)"
		
		$Bar/Description.text += " | Score: " + str(score) + suffix

	var i = 0
	for button in $Buttons.get_children():
		if (i == selected):
			button.selected = true
		else:
			button.selected = false
		
		i += 1
	
	if (Input.is_action_just_pressed("confirm")):
		$Timer.start()
		get_node("Sounds/ConfirmStream").play()
		
		var button = $Buttons.get_child(selected)
		button.get_node("AnimationPlayer").play("selected")
		
		var _o = 0
		for otherButtons in $Buttons.get_children():
			if (i != selected):
				otherButtons.visible = false
			_o += 1
			
		choseOption = true
	
func createMenuObjects():
	var i = 0
	for option in options:
		var button = BUTTON_SCENE.instance()
		button.type = options[option]
		button.text = option.to_upper()
		button.position.y = (i * 100)
		button.position.x -= (i * 5)
		button.position += optionsOffset
		
		$Buttons.add_child(button)
		
		i += 1

func option_logic(name):
	match (name):
		"mario forever":
			Main.change_playstate("Forever-Syndrome", Main.difficulties[2], 1)
		"remix":
			Main.change_playstate("Forever-Syndrome-Remix", Main.difficulties[2], 1)
		"bullet bill":
			Main.change_playstate("Bullet-Time", Main.difficulties[2], 1)
		"options":
			Main.change_scene("res://Scenes/States/OptionsState.tscn")
		_:
			Main.change_to_main_menu()

func _on_Timer_timeout():
	option_logic(options.keys()[selected])
