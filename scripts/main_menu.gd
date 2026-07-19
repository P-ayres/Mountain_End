extends Node2D

var scene = "scenes/game.tscn"

func _on_start_pressed() -> void:
	SceneTransition.change_scene(scene)


func _on_quit_pressed() -> void:
	get_tree().quit()
