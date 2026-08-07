extends Node2D

@onready var default_end: CanvasLayer = $DefaultEnd
@onready var good_end: CanvasLayer = $GoodEnd

@export_file var scene = "scenes/main_menu.tscn"

func _ready() -> void:
	if GameSystem.item.has("divine_painting"):
		SfxManager.stop()
		good_end.visible = true
		SfxManager.play_sfx("GoodEndingMusic")
	else:
		default_end.visible = true

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		SfxManager.stop()
		GameSystem.reset_game()
		SceneTransition.change_scene(scene)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
