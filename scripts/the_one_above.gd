extends Node2D

@onready var animatted_end: AnimatedSprite2D = $TheOneAbove

var ended = false
var scene = "scenes/end_screen.tscn"

func _ready() -> void:
	animatted_end.play("FINAL")
	await get_tree().create_timer(6.5).timeout
	SfxManager.play_sfx("WildCard")
	await get_tree().create_timer(3).timeout
	SfxManager.play_sfx("Kill")

func _process(_delta: float) -> void:
	await animatted_end.animation_finished
	await get_tree().create_timer(0.3).timeout
	ended = true
	if ended:
		SceneTransition.change_scene(scene)
