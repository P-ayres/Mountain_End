extends Node

var active_sfx_stream: AudioStreamPlayer

@export_group("Main")
@export var clips: Node

func play_sfx(audio_name: String, from_position: float = 0.0, skip_restart: bool = false) -> void:
	if skip_restart and active_sfx_stream and active_sfx_stream.name == audio_name:
		return
		
	active_sfx_stream = clips.get_node(audio_name)
	active_sfx_stream.play(from_position)

func stop():
	active_sfx_stream.stop()
