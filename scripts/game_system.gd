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

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func pause_game():
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false

	elif current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_game()
