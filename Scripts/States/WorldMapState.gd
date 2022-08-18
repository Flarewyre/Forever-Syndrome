extends Node2D

#0: horizontal
#1: vertical
#2: top left corner
#3: top right corner
#4: bottom left corner
#5: bototm right corner

onready var character = $Character
onready var paths = $Paths
onready var tween = $Tween

var moving = false
var move_dir : Vector2
export var current_tile : Vector2

func _ready():
	tween.connect("tween_completed", self, "stop_moving")
	Conductor.play_song("res://Assets/Music/overworldMap.ogg", 102, 1)
	init_map()

func init_map():
	character.position = get_world_pos(current_tile)

func get_world_pos(tile_pos : Vector2):
	return paths.map_to_world(tile_pos) * paths.scale

func start_moving(direction : Vector2):
	if moving: return
	
	var cell = paths.get_cell(current_tile.x + direction.x, current_tile.y + direction.y)
	if cell != 0 && cell != 1: return
	
	var is_move_input : bool
	var is_spot : bool
	var move_time : float
	moving = true
	is_move_input = true
	
	while !is_spot:
		current_tile += direction
		move_time += 0.2
		cell = paths.get_cell(current_tile.x, current_tile.y) 
		if cell != 0 && cell != 1:
			is_spot = true
	tween.interpolate_property(character, "position", character.position, get_world_pos(current_tile), move_time)
	tween.start()
	
	move_dir = direction

func stop_moving(object, key):
	moving = false

	var cell = paths.get_cell(current_tile.x, current_tile.y) 
	if cell > 5:
		$Sounds/MapMove.play()
	else:
		if cell == 2:
			if move_dir.x == 0:
				start_moving(Vector2(-1, 0))
			else:
				start_moving(Vector2(0, 1))
		elif cell == 3:
			if move_dir.x == 0:
				start_moving(Vector2(1, 0))
			else:
				start_moving(Vector2(0, 1))
		elif cell == 4:
			if move_dir.x == 0:
				start_moving(Vector2(-1, 0))
			else:
				start_moving(Vector2(0, -1))
		elif cell == 5:
			if move_dir.x == 0:
				start_moving(Vector2(1, 0))
			else:
				start_moving(Vector2(0, -1))

func enter_level():
	moving = true
	$AnimationPlayer.play("enter_level")

func change_scene():
	Main.change_playstate("Viper-Tears", "normal", 1)

func _input(event):
	if moving: return

	var direction: Vector2
	if event.is_action_pressed("left"):
		direction = Vector2(-1, 0)
	if event.is_action_pressed("right"):
		direction = Vector2(1, 0)
	if event.is_action_pressed("up"):
		direction = Vector2(0, -1)
	if event.is_action_pressed("down"):
		direction = Vector2(0, 1)
	if event.is_action_pressed("confirm"):
		enter_level()
	
	if direction != Vector2():
		start_moving(direction)
