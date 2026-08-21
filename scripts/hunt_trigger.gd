extends Area2D

@export var target: Node2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_set_hunt(true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_set_hunt(false)

func _set_hunt(value: bool) -> void:
	if target and target.has_method("set_hunt_forced"):
		target.set_hunt_forced(value)
