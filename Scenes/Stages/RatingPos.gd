extends Position2D

export(NodePath) var current_scene_path
onready var current_scene = get_node(current_scene_path)

var bf
var relative_pos

func _ready():
	for i in range(5):
		yield(get_tree(), "physics_frame")
	bf = current_scene.get_node("Characters/Boyfriend Forever")
	relative_pos = global_position.y - bf.global_position.y

func _physics_process(delta):
	if bf != null:
		global_position.y = bf.global_position.y + relative_pos
