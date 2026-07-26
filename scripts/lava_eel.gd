extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $KillzoneArea

@export var speed := 250.0

enum State { IDLE, SURGING, CHASING, ATTACKING }
const ATTACK_FRAMES := [3, 4]    # frames com hitbox ativa

var state := State.IDLE
var player: CharacterBody2D
var is_player_in_attack_range := false


func _ready():
	killzone.monitoring = false
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if GameSystem.current_state != GameSystem.GameState.PLAYING:
		return

	if player == null:
		move_and_slide()
		return
		
	var direction = (player.global_position - global_position).normalized()

	match state:
		State.IDLE, State.SURGING:
			velocity = lerp(velocity, Vector2.ZERO, 10.0 * delta)
		State.CHASING:
			velocity = lerp(velocity, direction * speed, 8.5 * delta)
		State.ATTACKING:
			velocity = lerp(velocity, direction * (speed * 0.4), 8.5 * delta)

	# ataca de novo a cada frame em que o player estiver no alcance
	if state == State.CHASING and is_player_in_attack_range:
		attack()

	move_and_slide()

# --- Perseguição --------------------------------------------------

func start_chase() -> void:
	# Já está perseguindo ou atacando
	if state != State.IDLE:
		return
	
	state = State.SURGING
	sprite.play("surge")
	await sprite.animation_finished
	
	# Se nada interrompeu o surge, começa a caçar o player
	if state == State.SURGING:
		state = State.CHASING
		sprite.play("walk")

#func _on_vision_area_body_entered(body: Node2D) -> void:
#	if body.is_in_group("Player"):
#		start_chase()

func _on_catch_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		start_chase()

func _on_vision_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		state = State.IDLE
		sprite.play("idle")

# --- Ataque --------------------------------------------------------

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_attack_range = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_attack_range = false

func attack() -> void:
	state = State.ATTACKING
	sprite.flip_h = player.global_position.x < global_position.x
	
	sprite.play("tail_attack")
	await sprite.animation_finished
	killzone.monitoring = false
	
	# Aguarda 0.2s antes de voltar a atacar
	await get_tree().create_timer(0.2).timeout
	
	# Se o player não saiu da area de visão, continua caçando o player
	if state == State.ATTACKING:
		state = State.CHASING
		sprite.play("walk")

# Liga a hitbox só nos frames de golpe
func _on_animated_sprite_2d_frame_changed() -> void:
	if not sprite:
		return
	
	var is_attack_frame := sprite.animation == &"tail_attack" and sprite.frame in ATTACK_FRAMES
	killzone.monitoring = is_attack_frame
