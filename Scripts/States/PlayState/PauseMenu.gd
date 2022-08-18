extends Node2D

var playState

var selectedDifficulty = 2
var selectedSpeed = 1

var inOptions = false

func _ready():
	var _c_loaded = get_tree().current_scene.connect("scene_loaded", self, "_scene_loaded")
	
	playState = get_tree().current_scene.current_scene
	
	#var label = $CanvasLayer/PauseMenu/Label
	#$Tween.interpolate_property(label, "rect_position:y", -100, label.rect_position.y, 1.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	#$Tween.interpolate_property(label, "modulate:a", 0, 1, 1.6, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	#$Tween.start()
	
	$AnimationPlayer.play("in")
	
	$CanvasLayer/PauseMenu/Options/Resume.connect("button_down", self, "resume")
	$CanvasLayer/PauseMenu/Options/Retry.connect("button_down", playState, "restart_playstate")
	$CanvasLayer/PauseMenu/Options/Option.connect("button_down", self, "toggleOptions", [true])
	$CanvasLayer/PauseMenu/Options/Exit.connect("button_down", Main, "change_to_main_menu")
	
	$CanvasLayer/OptionsMenu.enabled = false

func _process(_delta):
	if (get_tree().paused == false):
		queue_free()
	
	if (Input.is_action_just_pressed("cancel")):
		if (!inOptions):
			resume()
		elif (!$CanvasLayer/OptionsMenu/EditValue/ValueEdit.visible):
			toggleOptions(false)
	
	pause_text_process()
	
func pause_text_process():
	$CanvasLayer/PauseMenu/Label/Label.text = playState.song.to_upper()

func _scene_loaded():
	get_tree().paused = false

func toggleOptions(enable):
	if (enable):
		inOptions = true
		
		$CanvasLayer/OptionsMenu.enabled = true
		$CanvasLayer/OptionsMenu.visible = true
		
		$CanvasLayer/PauseMenu/Options.visible = false
		$CanvasLayer/PauseMenu.visible = false
	else:
		inOptions = false
		
		$CanvasLayer/OptionsMenu.enabled = false
		$CanvasLayer/OptionsMenu.visible = false
		
		$CanvasLayer/PauseMenu/Options.visible = true
		$CanvasLayer/PauseMenu.visible = true

func resume():
	playState.setup_strums()
	
	get_tree().paused = false
