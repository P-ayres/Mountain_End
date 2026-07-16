extends Node

var player_position = 0 #utilizar um inteiro para representar cada sala
var monster_position = 0  
var item = [] #chaves

enum GameState {
	PLAYING,
	PAUSED,
	GAME_OVER,
	VICTORY
} 
var current_state: GameState = GameState.PLAYING

var next_room_position = Vector2.ZERO

func pause_game():
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
	
	elif current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
