extends Node

var active_music_stream: AudioStreamPlayer

@export_group("Main")
@export var clips: Node
var last_scene: Node
var last_scene_name := ""

func _process(_delta):
	var scene := get_tree().current_scene
	
	if scene == null:
		return
	
	if scene.name != last_scene_name:
		last_scene_name = scene.name
		stop()
		update_music()

func update_music():
	var scene = get_tree().current_scene

	if scene == null:
		return
		
	if scene.name != last_scene_name:
		last_scene.name = scene.name
		stop()
		update_music()

	match scene.name:
		"main_menu":
			play_music("MainMenu")
		"Game":
			play_music("CaveAmbience")
		"Earth":
			play_music("CaveAmbience")
		"area_aquatica":
			play_music("WaterLevelAmbience")
		"Volcano":
			play_music("LavaLevelAmbience")
		"FinalScene":
			play_music("Wind")

func play_music(audio_name: String, from_position: float = 0.0, skip_restart: bool = false) -> void:
	if skip_restart and active_music_stream and active_music_stream.name == audio_name:
		return
		
	active_music_stream = clips.get_node(audio_name)
	active_music_stream.play(from_position)

func stop():
	if active_music_stream != null:
		active_music_stream.stop()
