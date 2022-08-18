extends Control

func _ready():
	var MusicStream = get_tree().current_scene.get_node("Music/MusicStream")
	var length = MusicStream.stream.get_length()
	var playback_pos = MusicStream.get_playback_position()
	
	var progress = playback_pos / length
	$Dots.region_rect.size.x = (352 * progress) + 48
	$Dots.region_rect.size.x = floor($Dots.region_rect.size.x / 16) * 16
	$AnimatedSprite.position.x = ($Dots.region_rect.size.x * 2) + 24
