extends Area2D

@onready var timer: Timer = $Timer
@onready var fade: AnimationPlayer = $Fade/AnimationPlayer


func _on_body_entered(_body: Node2D) -> void:
	print("you died!")
	fade.play("fade_in")
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
