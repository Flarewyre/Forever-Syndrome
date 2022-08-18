extends Area2D

onready var parent = get_parent()

var velocity : Vector2
export var target := Vector2(620, 370)
var can_move : bool

export var accel : float
export var move_speed : float
export var rot_speed : float

func _ready():
	connect("area_entered", self, "hit")
	randomize()

func hit(area):
	if !can_move: return
	parent.get_parent().get_parent().get_node("HealthSystem").note_miss(0, false)

func delay_target(new_target):
	yield(get_tree().create_timer(0.4), "timeout")
	target.y = new_target

func _physics_process(delta):
	var move_direction = Vector2(0, 0)
	if can_move:
		if Input.is_action_pressed("left"):
			move_direction.x -= 1;
		if Input.is_action_pressed("right"):
			move_direction.x += 1;
		if Input.is_action_pressed("up"):
			move_direction.y -= 1;
		if Input.is_action_pressed("down"):
			move_direction.y += 1;
	else:
		var distance = Vector2(target.x - global_position.x, target.y - global_position.y)
		if abs(distance.x) > 16:
			move_direction.x = sign(distance.x)
		if abs(distance.y) > 16:
			move_direction.y = sign(distance.y)
	
	var speed = move_speed if can_move else move_speed / 1.25
	var acceleration = accel if can_move else accel * 1.25
	velocity.x = increment_towards(velocity.x, speed * move_direction.x, delta * acceleration)
	velocity.y = increment_towards(velocity.y, speed * move_direction.y, delta * acceleration)
	parent.global_position += velocity * delta
	
	var sprite = parent.get_node("Sprite")
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, -move_direction.y * 10, delta * rot_speed)

func increment_towards(value, target, increment):
	if value > target:
		value -= increment
		if value <= target:
			value = target
	if value < target:
		value += increment
		if value >= target:
			value = target
	return value
