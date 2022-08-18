extends Node2D

export(Array, Resource) var blocks
export var speed = 0;
var flip = false
var block = null

onready var stage = get_parent().get_parent()

func _ready():
	randomize()

func spawn_block():
	flip = (randi() % 2) == 1

	block = blocks[rand_range(0, blocks.size())].instance();
	position.x = 1000
	position.y = 560 if !flip else 176
	scale.y = 4 if !flip else -4
	add_child(block)
	
	if is_instance_valid(stage) && stage.get_node("Characters").get_child_count() > 0:
		stage.get_node("Characters/Boyfriend Lakitu/Area2D").target.y = 176 if !flip else 560
		stage.get_node("Characters/Bullet Bill/Area2D").delay_target(176 if !flip else 560)

func _physics_process(delta):
	position.x -= speed;
	if position.x <= -2000:
		if is_instance_valid(block):
			block.queue_free()
		spawn_block()
