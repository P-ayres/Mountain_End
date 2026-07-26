extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		SfxManager.play_sfx("Kill")
		GameSystem.pause_game()
		print("you died!")
		SceneTransition.reload_scene();
