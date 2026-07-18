extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_prompt: PanelContainer = $InteractionPrompt

@export var is_door_visible: bool = true
@export var needed_key = ""
@export var door_type = "normal"
@export var door_animation = "open_normal"

@export_file("*.tscn") var scene = ""
@export var next_scene_position: Vector2 = Vector2.ZERO

var is_in_range: bool = false
var is_interractable = true


func _ready():
	animated_sprite_2d.play(door_type)
	animated_sprite_2d.visible = is_door_visible

func _process(_delta):
	if(is_in_range and is_interractable and Input.is_action_just_pressed("interact") && (!needed_key or GameSystem.item.has(needed_key))):
		if scene.is_empty():
			push_warning("porta sem destino!")
			return

		if next_scene_position != Vector2.ZERO:
			GameSystem.next_room_position = next_scene_position

		is_interractable = false
		animated_sprite_2d.play(door_animation)
		await get_tree().create_timer(0.2).timeout
		SceneTransition.change_scene(scene)

func _on_body_entered(_body: Node2D) -> void:
	print("entered range")
	is_in_range = true;
	interaction_prompt.show_prompt()

func _on_body_exited(_body: Node2D) -> void:
	print("left range")
	is_in_range = false;
	interaction_prompt.hide_prompt()
