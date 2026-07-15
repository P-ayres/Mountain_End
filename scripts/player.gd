extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var map_panel = $map
@onready var player_animation: AnimatedSprite2D = $AnimatedSprite2D

var flipped = false

func use_map():
	if map_panel.visible==false:
		map_panel.visible=true
	elif map_panel.visible==true:
		map_panel.visible=false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		GameSystem.pause_game()
	if Input.is_action_just_pressed("map"):
		use_map()

func _physics_process(delta: float) -> void:
	if GameSystem.current_state == GameSystem.GameState.PLAYING:
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("move_up") and is_on_floor():
			player_animation.play("jump")
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
		var dead_zone = 0.2
		if direction:
			velocity.x = direction * SPEED
			if direction > dead_zone:
				player_animation.play("walk")
				if (flipped):
					flipped = false
					player_animation.flip_h = false
				
			elif direction < -dead_zone:
				flipped = true
				player_animation.flip_h = true
				player_animation.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			player_animation.play("idle")

		move_and_slide()
