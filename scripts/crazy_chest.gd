extends AnimatedSprite2D

@onready var chest_animation: AnimatedSprite2D = $"."


func _process(_delta):
	chest_animation.flip_h = true
	
