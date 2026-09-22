extends Node

var active_streams: Dictionary = {}
var last_scene_name := ""

@export_group("Main")
@export var clips: Node

func _process(_delta):
	var scene := get_tree().current_scene
	if scene == null:
		return
	if scene.name != last_scene_name:
		last_scene_name = scene.name
		stop_all()
		update_music()

func update_music():
	var scene := get_tree().current_scene
	if scene == null:
		return

	match scene.name:
		"main_menu":
			play_music("MainMenu")
		"Game":
			play_music("CaveAmbience")
		"Earth":
			play_music("Suspense")
		"area_aquatica":
			play_music("Tensao")
		"Volcano":
			play_music("Energia")
		"Forest":
			play_music("Forest")
		"FinalScene":
			play_music("Conclusao")
			play_music("Wind")

func play_music(audio_name: String, from_position: float = 0.0, skip_restart: bool = false) -> void:
	if skip_restart and active_streams.has(audio_name):
		return

	var music_player: AudioStreamPlayer = clips.get_node(audio_name)
	music_player.play(from_position)
	active_streams[audio_name] = music_player

func stop_music(audio_name: String) -> void:
	if active_streams.has(audio_name):
		active_streams[audio_name].stop()
		active_streams.erase(audio_name)

func stop_all() -> void:
	for music_player in active_streams.values():
		if is_instance_valid(music_player):
			music_player.stop()
	active_streams.clear()
