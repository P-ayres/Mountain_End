extends Node2D

@export_file var scene = "scenes/main_menu.tscn"

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		SceneTransition.change_scene(scene)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
