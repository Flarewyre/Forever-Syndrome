extends Node2D

export(NodePath) var current_scene_path
onready var current_scene = get_node(current_scene_path)

export var activated = false
var was_activated = false

var og_pos0 : Vector2
var relative_pos0 : Vector2

var og_pos1 : Vector2
var relative_pos1 : Vector2

var time : float
var pos_multi : float

func _ready():
	for i in range(5):
		yield(get_tree(), "physics_frame")
	og_pos0 = current_scene.get_node("Characters/Mario Forever").global_position
	og_pos1 = current_scene.get_node("Characters/Boyfriend Forever").global_position
	
	relative_pos0 = $Platform2.global_position - og_pos0
	relative_pos1 = $Platform.global_position - og_pos1

func _physics_process(delta):
	if activated:
		was_activated = true
		
		var mario = current_scene.get_node("Characters/Mario Forever")
		var bf = current_scene.get_node("Characters/Boyfriend Forever")
		
		time += delta
		var sine = sin(time * 3) * 96
		bf.global_position.y = og_pos1.y + sine
		$Platform.global_position.y = bf.global_position.y + relative_pos1.y

		mario.global_position.y = og_pos0.y - sine
		$Platform2.global_position.y = mario.global_position.y + relative_pos0.y
	
	if !activated && was_activated:
		var mario = current_scene.get_node("Characters/Mario Forever")
		var bf = current_scene.get_node("Characters/Boyfriend Forever")
		
		mario.global_position.y = lerp(mario.global_position.y, og_pos0.y, delta * 4)
		bf.global_position.y = lerp(bf.global_position.y, og_pos1.y, delta * 4)
		
		if stepify(mario.global_position.y, 1) == stepify(og_pos0.y, 1) && stepify(bf.global_position.y, 1) == stepify(og_pos1.y, 1):
			was_activated = false
