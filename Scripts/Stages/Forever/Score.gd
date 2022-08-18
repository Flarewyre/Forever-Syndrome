extends Sprite

export(NodePath) var current_scene_path
onready var current_scene = get_node(current_scene_path)

func _process(delta):
	var i = 0
	for num in get_children():
		var score = abs(current_scene.score)
		num.visible = (get_child_count() - i) <= str(score).length()
		if num.visible:
			num.frame = int(str(score).pad_zeros(7)[i])
		i += 1
	
	modulate = Color.red if current_scene.score < 0 else Color.white
