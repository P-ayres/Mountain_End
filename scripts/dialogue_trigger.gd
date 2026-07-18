extends Node2D

@onready var dialogue_ui = get_tree().current_scene.get_node("dialogue_ui/canvas")
@onready var speaker: RichTextLabel = get_tree().current_scene.get_node("dialogue_ui/canvas/speaker")
@onready var dialogue_text: RichTextLabel = get_tree().current_scene.get_node("dialogue_ui/canvas/dialogue_text")
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Player")

@export var dialogues: Array[String]
@export var speakers: Array[String]
@export var character: Node2D

var current_dialogue = -1
var started = false

func _ready() -> void:
	dialogue_ui.get_node("continue").connect("pressed", Callable(self, "continue_dialogue"))
	dialogue_ui.visible = false

func start_dialogue(body):
	if body == player and !started:
		started = true
		GameSystem.pause_game()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		dialogue_ui.visible = true
		continue_dialogue()
	

func end_dialogue():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GameSystem.pause_game()
	dialogue_ui.visible = false

func continue_dialogue():
	current_dialogue += 1
	if current_dialogue < dialogues.size():
		dialogue_text.text = dialogues[current_dialogue]
		speaker.text = speakers[current_dialogue]
	else:
		end_dialogue()
