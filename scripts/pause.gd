extends Control

@onready var pause_panel = $Canvas

var playing = GameSystem.GameState.PLAYING;
var paused = GameSystem.GameState.PAUSED;

func toggle_pause():
	if pause_panel.visible==false and GameSystem.current_state == playing:
		pause_panel.visible=true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GameSystem.pause_game()
	elif pause_panel.visible==true and GameSystem.current_state == paused:
		pause_panel.visible=false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		GameSystem.pause_game()

func quit_game():
	get_tree().quit()
