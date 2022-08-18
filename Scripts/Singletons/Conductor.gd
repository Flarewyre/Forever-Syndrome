extends Node

signal beat_hit()
signal half_beat_hit()
signal on_beat(beat)
signal on_step(step)

const SCROLL_DISTANCE = 1.6 # units
const SCROLL_TIME = 2 # sec

const COUNTDOWN_SOUNDS = [preload("res://Assets/Sounds/intro3.ogg"),
						preload("res://Assets/Sounds/intro2.ogg"),
						preload("res://Assets/Sounds/intro1.ogg"),
						preload("res://Assets/Sounds/introGo.ogg")]
						
const PLAY_STATE = preload("res://Scenes/States/PlayState.tscn")

var songData

var songName
var songDifficulty

var bpm = 100.0
var scroll_speed = 1
var song_speed = 1

var MusicStream
var VocalStream

var countingDown = false
var countdown = 0
var countdownState = 0
var lastCount = 0

var useCountdown = false

var beatCounter = 1
var halfBeatCounter = 1

var loaded = false
var muteVocals = false

var songPositionMulti = 0

var noteThread
var notesFinished = false

var chartType = null

var crochet = 0
var stepCrochet = 0

var lastStep = 0
var curStep = 0

var lastBeat = 0
var curBeat = 0

var startingPosition = 0

func _ready():
	var streams = get_tree().current_scene.get_node("Music")
	MusicStream = streams.get_node("MusicStream")
	VocalStream = streams.get_node("VocalStream")

	noteThread = Thread.new()
	noteThread.start(self, "create_notes")
	
	var _c_loaded = get_tree().current_scene.connect("scene_loaded", self, "_scene_loaded")

func _scene_loaded():
	loaded = true
	
func _process(delta):
	if !(loaded):
		return
		
	if (muteVocals):
		VocalStream.volume_db = -80
	else:
		VocalStream.volume_db = 0
		
	beat_process(delta)
	
	if (notesFinished):
		if (useCountdown):
			countdown_process(delta)
		
	var countdownMulti = ((countdown / (bpm / 60)) * 2)
	songPositionMulti = MusicStream.get_playback_position() - countdownMulti
	
	crochet = (60 / bpm)
	stepCrochet = crochet / 4
	
	update_step()

func _exit_tree():
	noteThread.wait_to_finish()

func play_song(song, newerBpm, speed = 1, force=true):
	if (song is String):
		song = load(song)
		
	if (!force):
		if (MusicStream.stream == song && song_speed == speed):
			return
		
	MusicStream.stream = song
	
	song_speed = speed
	change_bpm(newerBpm)
	
	MusicStream.pitch_scale = song_speed
	MusicStream.play()
	
	VocalStream.stop()
	
	useCountdown = false
	
	muteVocals = false

func play_chart(song, difficulty, speed = 1):
	songName = song
	
	var difExt = "-" + difficulty
	
	match difficulty:
		"easy":
			songDifficulty = 0
		"normal":
			songDifficulty = 1
			difExt = ""
		"hard":
			songDifficulty = 2
	
	if (songData == null):
		songData = load_song_json(songName, difExt)
	
	var songPath = songData["_dir"]
	
	song_speed = speed
	change_bpm(songData["bpm"])
	
	if songData.has("speed"):
		scroll_speed = songData["speed"]
	else:
		scroll_speed = 1 
	
	scroll_speed = sqrt(scroll_speed)
	
	create_notes()
	
	MusicStream.stream = Mods.mod_ogg(songPath + "Inst.ogg")
	MusicStream.pitch_scale = song_speed
	
	if (songData["needsVoices"]):
		VocalStream.stream = Mods.mod_ogg(songPath + "/Voices.ogg")
		VocalStream.pitch_scale = song_speed
	else:
		VocalStream.stream = null
		
	MusicStream.seek(startingPosition)
	VocalStream.seek(startingPosition)
	
	countdown = 3
	useCountdown = true
	
	if (songData.has("type")):
		chartType = songData["type"]
	else:
		chartType = null
	
	#var countDownOffset = get_tree().current_scene.current_scene.notes[0][0] - ((countdown / (bpm / 60)) * 2)
	var countDownOffset = 0
	if (countDownOffset < 0):
		countdown -= countDownOffset
		
	muteVocals = false

func change_bpm(newBpm):
	bpm = float(newBpm)
	
	halfBeatCounter = 1
	beatCounter = 1

func create_notes():
	notesFinished = false
	
	var playState = get_tree().current_scene.current_scene
	
	var temp_array = []
	var section_array = []
	var last_note
	
	var sections = []
	var events = []
	
	for section in songData["notes"]:
		var section_time = (((60 / bpm) / 4) * 16) * sections.size()
		
		var altAnim = false
		if ("altAnim" in section.keys()):
			altAnim = true
		
		var sectionData = [section_time, section["mustHitSection"], altAnim]
		
		sections.append(sectionData)
		
		for note in section["sectionNotes"]:
			var strum_time = (note[0] + Settings.offset) / 1000
			var sustain_length = int(note[2]) / 1000.0
			var direction = int(note[1])
			
			if (startingPosition != 0):
				if (strum_time < startingPosition):
					continue
			
			var arg3 = null
			if (len(note) > 3):
				arg3 = note[3] # legit could be anything at this fucking point (mainly used for psych notes)

			if (!section["mustHitSection"]):
				if (direction <= 3):
					direction += 4
				else:
					direction -= 4
					
			var noteData = [strum_time, direction, sustain_length, arg3]
			
			if (last_note != null):
#				if (last_note[0] == strum_time):
#					last_note[1] += 1
#					section_array.append(last_note)
				temp_array.append(last_note)
				if (!section_array.empty()):
					temp_array.append_array(section_array)
					section_array = []
				last_note = noteData
			else:
				last_note = noteData
		
		if (section.has("sectionEvents")):
			for event in section["sectionEvents"]:
				var eventData = [event[0] / 1000, event[1], event[2], event[3]]
				
				events.append(eventData)
	
	temp_array.append(last_note)
	
	# sort notes ?
	var notes = []
	if (len(temp_array) > 1 && temp_array[0] != null):
		var strum_times = []
		
		for tmp_note in temp_array:
			strum_times.append(tmp_note[0])
				
		strum_times.sort()
			
		while !temp_array.empty():
			var index = 0
			
			while strum_times[0] != temp_array[index][0]:
				index += 1
			
			notes.append(temp_array[index])
			
			strum_times.remove(0)
			temp_array.remove(index)
	
	# sort events
	var sortedEvents = []
	for event in events:
		sortedEvents.append(event[0])
	
	sortedEvents.sort()
	var trueSortedEvents = []
	
	for sortedEvent in sortedEvents:
		for event in events:
			if (event[0] == sortedEvent):
				trueSortedEvents.append(event)
	
	# set playState shit
	playState.notes = notes
	playState.sections = sections
	playState.events = trueSortedEvents
	
	notesFinished = true

func countdown_process(delta):
	var playState = get_tree().current_scene.current_scene
	
	if (countdown > 0):
		countingDown = true
		countdown -= ((bpm / 60) / 2) * song_speed * delta
	
	if (countingDown):
		var animPlayer = playState.get_node_or_null("HUD/HudElements/AnimationPlayer")
		var stream = playState.get_node_or_null("Audio/CountdownStream")
	
		countdownState = ceil((fmod(countdown / 5, countdown) * 10))
		
		if (animPlayer == null):
			return
		
		if (animPlayer.get_current_animation() == "RESET"):
			animPlayer.play("ready")
		
		if (!animPlayer.is_playing() && animPlayer.get_current_animation() == "ready"):
			animPlayer.play("fight")

		#elif (!animPlayer.is_playing() && animPlayer.get_current_animation() == "fight"):
		if (true):
			start_song()
			
			countingDown = false
			countdown = 0

func start_song():
	MusicStream.play(startingPosition)
	VocalStream.play(startingPosition)
	
	change_bpm(bpm)

func play_countdown_sound(stream, snd):
	if (stream.stream != snd):
		stream.stream = snd
		stream.play()

func beat_process(delta):
	#beatCounter -= ((bpm / 60) * song_speed) * delta
	
	if (beatCounter <= 0):
		beatCounter = beatCounter + 1
		halfBeatCounter += 1
		emit_signal("beat_hit")
		
		if (halfBeatCounter >= 2):
			emit_signal("half_beat_hit")
			halfBeatCounter = 0

func load_song_json(song, difExt="", path=null):
	difExt = difExt.to_lower()
	
	var songPath = "res://Assets/Songs/" + song.to_lower() + "/"
	if (path != null):
		songPath = path + "/"
	
	var directory = Directory.new();
	if (!directory.dir_exists(songPath)):
		songPath = Mods.songsDir + "/" + song + "/"
	
	var file = File.new()	
	var jsonPath = songPath + song.to_lower() + difExt + ".json"
	
	if (!file.file_exists(jsonPath)):
		difExt = ""
		jsonPath = songPath + song.to_lower() + difExt + ".json"
	
	if (!file.file_exists(jsonPath)):
		return
	
	file.open(jsonPath, File.READ)
	
	var json = JSON.parse(file.get_as_text()).result["song"]
	json["_dir"] = songPath
	
	return json

func save_score(songName, score, fcType, dif=2):
	var file = ConfigFile.new()
	var err = file.load("user://data.ini")
	
	var scoreArray = file.get_value("SCORES", songName, [0, 0, 0])
	var curFC = file.get_value("FC", songName, 0)
	
	if scoreArray[dif] < score:
		scoreArray[dif] = score
	file.set_value("SCORES", songName, scoreArray)
	
	if curFC < fcType:
		file.set_value("FC", songName, fcType)
	
	file.save("user://data.ini")

func load_score(songName, dif=2):
	var file = ConfigFile.new()
	var err = file.load("user://data.ini")
	
	if err != OK:
		return 0
	
	var score = file.get_value("SCORES", songName, [0, 0, 0])
	return score[dif]

func load_fc(songName):
	var file = ConfigFile.new()
	var err = file.load("user://data.ini")
	
	if err != OK:
		return 0
	
	var fcType = file.get_value("FC", songName, 0)
	return fcType

func update_step():
	curStep = floor(songPositionMulti / stepCrochet);
	if (curStep != lastStep):
		emit_signal("on_step", curStep)
	
	curBeat = floor(curStep / 4);
	if (curBeat != lastBeat):
		emit_signal("on_beat", curBeat)
		
		halfBeatCounter += 1
		emit_signal("beat_hit")
		print(curBeat)
		
		if (halfBeatCounter >= 2):
			emit_signal("half_beat_hit")
			halfBeatCounter = 0
	
	lastStep = curStep
	lastBeat = curBeat
