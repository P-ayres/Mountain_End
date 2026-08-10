extends Area2D

@onready var interaction_prompt: PanelContainer = $InteractionPrompt
@onready var painting: Panel = $PaintingFrame
@onready var item: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogue: Area2D = $painting_dialogue/trigger

var player: CharacterBody2D
var is_in_range: bool = false;
var collected: bool = false;

func _ready() -> void:
	dialogue.monitoring = false
	player = get_tree().get_first_node_in_group("Player")


func _process(_delta: float) -> void:
	if(is_in_range and Input.is_action_just_pressed("interact")):
		show_painting()
	if collected: 
		interaction_prompt.hide_prompt()

func _on_body_entered(_body: Node2D) -> void:
	print("entered range")
	is_in_range = true;
	interaction_prompt.show_prompt()

func _on_body_exited(_body: Node2D) -> void:
	print("left range")
	is_in_range = false;
	interaction_prompt.hide_prompt()

func show_painting():
	if !painting.visible and !collected:
		GameSystem.item.append("divine_painting")
		print(GameSystem.item)
		collected = true
		painting.visible = true
		GameSystem.pause_game()
	elif painting.visible and Input.is_action_just_pressed("interact"):
		GameSystem.pause_game()
		painting.visible = false
		item.visible = false
		dialogue.monitoring = true
