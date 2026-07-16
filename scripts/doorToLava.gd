extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_prompt: PanelContainer = $InteractionPrompt
@onready var loading_fade: AnimationPlayer = $"../../LoadingFade/AnimationPlayer"
@onready var fading_timer: Timer = $"../../FadingTimer"

@export var needed_key = ""

var is_in_range = false;

func _process(_delta):
	if(is_in_range and Input.is_action_just_pressed("interact") && GameSystem.item.has(needed_key)):
		animated_sprite_2d.play("open")
		loading_fade.play("fade_in")
		fading_timer.start()

func _on_body_entered(_body: Node2D) -> void:
	print("entered range")
	is_in_range = true;
	interaction_prompt.show_prompt()

func _on_body_exited(_body: Node2D) -> void:
	print("left range")
	is_in_range = false;
	interaction_prompt.hide_prompt()

func _on_fading_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/volcano.tscn")
	
