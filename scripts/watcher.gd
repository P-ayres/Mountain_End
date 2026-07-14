extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_in_range: bool = false;

func _process(_delta: float) -> void:
	if(is_in_range):
		print("AVISTADO")

func _on_body_entered(_body: Node2D) -> void:
	print("entered range")
	is_in_range = true;
	animated_sprite_2d.play("watching")


func _on_body_exited(_body: Node2D) -> void:
	print("left range")
	is_in_range = false;
	animated_sprite_2d.play("sleep")
