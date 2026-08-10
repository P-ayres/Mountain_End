extends Node2D

@onready var dialogue: Area2D = $area_dialogue/trigger

@export var enemy_saw = ""

func _ready() -> void:
	dialogue.monitoring = false
	await get_tree().create_timer(0.2).timeout
	if !GameSystem.dialogue_check.has(enemy_saw):
		dialogue.monitoring = true
		GameSystem.dialogue_check.append(enemy_saw)
