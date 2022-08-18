extends Sprite

export(NodePath) var current_scene_path
onready var current_scene = get_node(current_scene_path)

func _process(delta):
	var i = 0
	for num in get_children():
		num.visible = i < str(current_scene.misses).pad_zeros(2).length()
		if num.visible:
			num.frame = int(str(current_scene.misses).pad_zeros(2)[i])
		i += 1
