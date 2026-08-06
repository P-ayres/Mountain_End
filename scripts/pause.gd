extends Control

@onready var pause_panel = $Canvas

func toggle_pause():
	if pause_panel.visible==false:
		pause_panel.visible=true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GameSystem.pause_game()
	elif pause_panel.visible==true:
		pause_panel.visible=false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		GameSystem.pause_game()

func quit_game():
	get_tree().quit()
