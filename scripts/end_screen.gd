extends Node2D

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		GameSystem.finish_game()
