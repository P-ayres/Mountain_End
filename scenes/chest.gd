extends AnimatedSprite2D


@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if Input.is_physical_key_pressed(KEY_F):
		_animated_sprite.play("open")
	else: 
		return;
