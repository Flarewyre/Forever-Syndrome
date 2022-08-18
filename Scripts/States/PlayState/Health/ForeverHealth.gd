extends Health

export(int) var max_health
export(Array, StreamTexture) var spritesheets

export(float) var gravity = 0.0
export(float) var velocity = 0.0
export(bool) var velocity_active = false

var damage_cooldown = 0.0

func setup_health():
	powerup_visuals()

func powerup_visuals():
	get_parent().PlayerCharacter.get_node("Sprite").texture = spritesheets[health - 1]

func note_miss(note_type, passed):
	if damage_cooldown <= 0:
		damage_cooldown = 1.5
		health -= 1
		
		if health == 0 && Settings.pussyMode:
			health = 1
		powerup_visuals()
		
		if health > 0:
			$Powerdown.play()

func health_bar_process(delta):
	if (health <= 0):
		Conductor.MusicStream.stop()
		Conductor.VocalStream.stop()
		
		game_over()

	if (Input.is_action_just_pressed("reset")):
		health = 0
		get_parent().PlayerCharacter.visible = false

func _process(delta):
	if get_tree().paused: return
	if damage_cooldown > 0:
		damage_cooldown -= delta
		get_parent().PlayerCharacter.visible = !get_parent().PlayerCharacter.visible
		if damage_cooldown <= 0:
			damage_cooldown = 0
			get_parent().PlayerCharacter.visible = true

func game_over():
	pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true
	
	var character = get_parent().PlayerCharacter
	$BF.global_position = character.get_node("Sprite").global_position
	$BF.visible = true
	$AnimationPlayer.play("die")
	character.visible = false

func _physics_process(delta):
	if velocity_active:
		velocity += gravity
		$BF.global_position.y += velocity * delta

func reload():
	Main.change_playstate(get_parent().song, get_parent().difficulty, get_parent().speed, get_parent().storySongs, true, null, get_parent().chartingMode)
