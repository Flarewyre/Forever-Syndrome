extends AnimationPlayer

func _ready():
	var _c_beat = Conductor.connect("beat_hit", self, "beat_hit")
	play("RESET")

func beat_hit():
	if "beat_" + str(Conductor.curBeat) in get_animation_list():
		play("beat_" + str(Conductor.curBeat))

func texture_fps(texture : AnimatedTexture, fps : float):
	texture.fps = fps
