extends AnimatedSprite2D

var is_in_range = false;

func _process(_delta):
	if(is_in_range && Input.is_action_just_pressed("ui_accept")):
		play("open")

func _on_area_2d_body_entered(_body: Node2D) -> void:
	is_in_range = true;
	print("entered range")

func _on_area_2d_body_exited(_body: Node2D) -> void:
	is_in_range = false;
	print("left range")
