extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_prompt: PanelContainer = $InteractionPrompt

var is_in_range = false;
@export var needed_key=""

func _process(_delta):
	animated_sprite_2d.hide()
	if(is_in_range and Input.is_action_just_pressed("interact") && GameSystem.item.has(needed_key)):
		await get_tree().create_timer(0.3).timeout
		#get_tree().change_scene_to_file("res://scenes/earth.tscn") ajustar para a cena final

func _on_body_entered(_body: Node2D) -> void:
	print("entered range")
	is_in_range = true;
	interaction_prompt.show_prompt()

func _on_body_exited(_body: Node2D) -> void:
	print("left range")
	is_in_range = false;
	interaction_prompt.hide_prompt()
