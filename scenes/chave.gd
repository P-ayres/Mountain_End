extends AnimatedSprite2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	hide_key() 


func _process(delta: float) -> void:
da	if (AnimatedSprite2D.animation_finished):
		show_key()

func show_key() -> void:
	visible = true

func hide_key() -> void:
	visible = false
a
