extends Area2D

@onready var interaction_prompt: PanelContainer = $InteractionPrompt
@onready var sign_img: Sprite2D = $Sprite2D

var is_in_range: bool = false;

func _process(_delta: float) -> void:
	if(is_in_range and Input.is_action_just_pressed("interact")):
		sign_img.visible = true
	if(sign_img.visible and (Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_accept"))):
		sign_img.visible = false

func _on_body_entered(_body: Node2D) -> void:
	print("entered range")
	is_in_range = true;
	interaction_prompt.show_prompt()

func _on_body_exited(_body: Node2D) -> void:
	print("left range")
	is_in_range = false;
	interaction_prompt.hide_prompt()
