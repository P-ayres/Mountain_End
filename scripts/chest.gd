extends AnimatedSprite2D
var closed:bool = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and closed:
		play("open_chest")
		await animation_finished
		closed = false
