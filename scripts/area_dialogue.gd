extends Node2D

@onready var dialogue: Area2D = $area_dialogue/trigger

@export var enemy_saw = ""

func _ready() -> void:
	dialogue.monitoring = false
	if !GameSystem.dialogue_check.has(enemy_saw):
		dialogue.monitoring = true
		GameSystem.dialogue_check.append(enemy_saw)
