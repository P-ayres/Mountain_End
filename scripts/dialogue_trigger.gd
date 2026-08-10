extends Node2D

@onready var dialogue_ui = get_tree().current_scene.get_node("dialogue_ui/canvas")
@onready var speaker: RichTextLabel = get_tree().current_scene.get_node("dialogue_ui/canvas/speaker")
@onready var dialogue_text: RichTextLabel = get_tree().current_scene.get_node("dialogue_ui/canvas/dialogue_text")
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")
@onready var actual_speed = player.SPEED

@export var dialogues: Array[String]
@export var speakers: Array[String]
@export var character: Node2D

var current_dialogue = -1
var started = false
var is_active = false

func _ready() -> void:
	dialogue_ui.get_node("continue").connect("pressed", Callable(self, "continue_dialogue"))
	dialogue_ui.visible = false
	
func _input(keyboardKey):
	if !is_active:
		return

	if dialogue_ui.visible and keyboardKey is InputEventKey and keyboardKey.pressed:
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("ui_accept"):
			continue_dialogue()
			get_viewport().set_input_as_handled()
			
func start_dialogue(body):
	if body == player and !started:
		is_active = true
		started = true
		player.SPEED = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		dialogue_ui.visible = true
		continue_dialogue()

func continue_dialogue():
	if !is_active:
		return

	current_dialogue += 1
	if current_dialogue < dialogues.size():
		dialogue_text.text = dialogues[current_dialogue]
		speaker.text = speakers[current_dialogue]
	else:
		end_dialogue()
		
func end_dialogue():
	is_active = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	player.SPEED = actual_speed
	dialogue_ui.visible = false
