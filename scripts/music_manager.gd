extends Node

var active_music_stream: AudioStreamPlayer

@export_group("Main")
@export var clips: Node
var last_scene: Node

func _process(_delta):
	if get_tree().current_scene != last_scene:
		last_scene = get_tree().current_scene
		stop()
		update_music()

func update_music():
	var scene = get_tree().current_scene

	if scene == null:
		return

	match scene.name:
		"Game":
			play_music("CaveAmbience")

func play_music(audio_name: String, from_position: float = 0.0, skip_restart: bool = false) -> void:
	if skip_restart and active_music_stream and active_music_stream.name == audio_name:
		return
		
	active_music_stream = clips.get_node(audio_name)
	active_music_stream.play(from_position)

func stop():
	if active_music_stream != null:
		active_music_stream.stop()
