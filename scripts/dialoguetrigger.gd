extends Node2D

@onready var speaker: RichTextLabel = get_tree().current_scene.get_node("dialogue_ui/Canvas/speaker")
@onready var dialogue_text: RichTextLabel = get_tree().current_scene.get_node("dialogue_ui/Canvas/dialogue_text")
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player")

@export var dialogues: Array[String]
@export var speakers: Array[String]
@export var character: Node2D 

var current_dialogue = -1
