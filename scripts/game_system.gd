extends Node

enum GameState {
	PLAYING,
	PAUSED,
	GAME_OVER,
	VICTORY
}

var current_state: GameState = GameState.PLAYING
var item = [] #chaves
var player_position = 0 #utilizar um inteiro para representar cada sala
var monster_position = 0
var next_room_position = Vector2.ZERO

var current_room_spawn = Vector2.ZERO
var current_room_item = []


func pause_game():
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING

	elif current_state == GameState.PLAYING:
		current_state = GameState.PAUSED

func reset_game():
	item = []
	current_room_spawn = Vector2.ZERO
	
func finish_game():
	SfxManager.stop()
	GameSystem.reset_game()
	SceneTransition.change_scene("scenes/main_menu.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
