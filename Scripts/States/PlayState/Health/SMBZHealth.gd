extends Health

const MISS_SOUNDS = [preload("res://Assets/Sounds/Hurt.wav")]

onready var healthShakePos = get_node("../HUD/HudElements/HealthBar").rect_position
var healthShakeTimer = 0
var healthShakeIntensity = 1

var rng = RandomNumberGenerator.new()

func setup_health():
	rng.randomize()
	
	if Settings.downScroll:
		get_node("../HUD/HudElements/HealthBar").rect_position.y = -404
		get_node("../HUD/HudElements/TextBar").rect_position.y = -454
	healthShakePos = get_node("../HUD/HudElements/HealthBar").rect_position

func note_miss(note_type, passed):
	var random = rng.randi_range(0, MISS_SOUNDS.size()-1)
	get_node("../Audio/MissStream").stream = MISS_SOUNDS[random]
	get_node("../Audio/MissStream").play()
	
	health -= 10.0
	shake_health()

func shake_health(time = 0.15, intensity = 8):
	healthShakeTimer = time
	healthShakeIntensity = intensity

func health_bar_process(delta):
	var bar = get_node("../HUD/HudElements/HealthBar")
	
	health = clamp(health, 0, 100)
	
	if (Conductor.countingDown && get_parent().misses == 0):
		oldHealth = lerp(oldHealth, health, 3 * delta)
		bar.value = oldHealth
	else:
		bar.value = health
	
	if (healthShakeTimer > 0):
		bar.rect_position = healthShakePos + Vector2(rng.randi_range(-healthShakeIntensity, healthShakeIntensity), rng.randi_range(-healthShakeIntensity, healthShakeIntensity))
		healthShakeTimer -= delta
	else:
		bar.rect_position = healthShakePos
	
	if (Input.is_action_just_pressed("reset")):
		health = 0
	
	if (health <= 0):
		Conductor.MusicStream.stop()
		Conductor.VocalStream.stop()
		
		get_parent().game_over()
