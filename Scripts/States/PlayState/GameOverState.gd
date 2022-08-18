extends Node2D

const GAMEOVER_MUSIC = preload("res://Assets/Music/gameOver.ogg")

var died = false
var doBop = false
var pressed = false

var song = "tutorial"
var difficulty = "hard"
var speed = 1
var storySongs = false
var chartingMode = false

var death_pos : Vector2
var pos = 0

func _ready():
	var _connect = Conductor.connect("half_beat_hit", self, "beat")
	death_pos = $DeathSprite.global_position
	
func _input(event):
	if (!pressed):
		if (event.is_action_pressed("confirm")):
			Conductor.MusicStream.stop()
			Conductor.VocalStream.stop()
			
			$EndStream.play()
			
			died = true
			doBop = false
			pressed = true
			$AnimationPlayer2.play("confirm")
	
	if (event.is_action_pressed("cancel")):
		Conductor.MusicStream.stop()
		Conductor.VocalStream.stop()
		
		Main.change_to_main_menu()
	
func _process(delta):
	death_pos.x = lerp(death_pos.x, $Camera2D.global_position.x, delta * 4.5)
	death_pos.y = lerp(death_pos.y, $Camera2D.global_position.y, delta * 4.5)
	
	$DeathSprite.global_position.x = stepify(death_pos.x, 9)
	$DeathSprite.global_position.y = stepify(death_pos.y, 9)
	#if (died):
		#$Camera2D.position = $DeathSprite.position

func _on_AnimationPlayer_animation_finished(anim_name):
	match (anim_name):
		"die":
			died = true
			doBop = true
			
			if (!pressed and Conductor.MusicStream.stream != GAMEOVER_MUSIC):
				Conductor.play_song(GAMEOVER_MUSIC, 100, 1, true)
			
			$AnimationPlayer.play("bop")
		"confirm":
			Main.change_playstate(song, difficulty, speed, storySongs, true, null, chartingMode)

func beat():
	if (doBop):
		$AnimationPlayer.play("bop")
