extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_prompt: PanelContainer = $InteractionPrompt

var is_in_range: bool = false

var chest_opened := false

@export var chest_item = "" 

func _process(_delta: float) -> void:
	if is_in_range and Input.is_action_just_pressed("interact") and not chest_opened:
		chest_opened = true
		animated_sprite_2d.play("open_chest")
		GameSystem.item.append(chest_item)
		chest_item = null
		

func _on_body_entered(_body: Node2D) -> void:
	print("entered range")
	if not chest_opened:
		is_in_range = true;
		interaction_prompt.show_prompt()

func _on_body_exited(_body: Node2D) -> void:
	print("left range")
	is_in_range = false;
	interaction_prompt.hide_prompt()
