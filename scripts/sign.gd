extends Area2D

@onready var interaction_prompt: PanelContainer = $InteractionPrompt
@onready var sign_img: Sprite2D = $Tutorial

var player: CharacterBody2D
var is_in_range: bool = false;

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta: float) -> void:
	if(is_in_range and Input.is_action_just_pressed("interact")):
		toggle_tutorial()
		return

func _on_body_entered(_body: Node2D) -> void:
	print("entered range")
	is_in_range = true;
	interaction_prompt.show_prompt()

func _on_body_exited(_body: Node2D) -> void:
	print("left range")
	is_in_range = false;
	interaction_prompt.hide_prompt()

func toggle_tutorial():
	if sign_img.visible==false:
		player.SPEED = 0
		sign_img.visible=true
	elif sign_img.visible==true:
		player.SPEED = 100
		sign_img.visible=false
