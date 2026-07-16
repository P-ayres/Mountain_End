extends Node2D

@onready var fade: AnimationPlayer = $LoadingFade/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade.play("fade_out")
