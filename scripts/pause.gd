extends Control

@onready var pause_panel = $Canvas

func _process(_delta: float) -> void:
	if pause_panel.visible==true and Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func toggle_pause():
	if pause_panel.visible==false:
		pause_panel.visible=true
		GameSystem.pause_game()
	elif pause_panel.visible==true:
		pause_panel.visible=false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		GameSystem.pause_game()

func quit_game():
	get_tree().quit()
