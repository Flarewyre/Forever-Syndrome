extends Sprite

var accuracy = 100.0
export(NodePath) var current_scene_path

onready var current_scene = get_node(current_scene_path)

func _process(delta):
	if (current_scene.hitNotes > 0):
		var totalNotes = float(current_scene.totalHitNotes + current_scene.realMisses)
		accuracy = round((float(current_scene.hitNotes) / totalNotes) * 10000) / 100
	
	var acc_string = str(accuracy).pad_zeros(3)
	$Num1.frame = int(acc_string[0])
	$Num2.frame = int(acc_string[1])
	$Num3.frame = int(acc_string[2])
	
	$Num1.visible = !($Num1.frame == 0)
	$Num2.visible = !($Num2.frame == 0 && $Num1.frame == 0)
	
	if (current_scene.usedBot):
		if (current_scene.totalHitNotes == current_scene.hitNotes):
			$Num0.visible = true
			$Num0.frame = 11
		else:
			$Num0.visible = false
			$Num1.visible = true
			$Num1.frame = 11
	elif (current_scene.realMisses == 0 && current_scene.misses == 0):
		if (current_scene.totalHitNotes == current_scene.hitNotes):
			$Num0.visible = true
		else:
			$Num0.visible = false
			$Num1.visible = true
			$Num1.frame = 38
	else:
		$Num0.visible = false

	var dec_string = str((accuracy - floor(accuracy)) * 100).pad_zeros(2)
	$Num5.frame = int(dec_string[0])
	$Num6.frame = int(dec_string[1])
