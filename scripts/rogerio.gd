extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $KillzoneArea
@onready var killzone_shape: CollisionShape2D = $KillzoneArea/CollisionShape2D

@export var speed := 250.0

enum State { IDLE, CHASING, BURROWING, TUNNELING, SURGING, ATTACKING }
const ATTACK_FRAMES := [1, 2]

var state := State.IDLE
var player: CharacterBody2D
var is_player_in_attack_range := false
var is_player_in_chase_range := false
var is_player_in_ambush_range := false
var killzone_offset_x := 0.0 	# posição original da hitbox, usado ao espelhar


func _ready():
	killzone.monitoring = false
	killzone_offset_x = killzone_shape.position.x
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if player == null:
		move_and_slide()
		return

	var direction = (player.global_position - global_position).normalized()

	# movimento: cada estado declara o seu
	match state:
		State.IDLE, State.BURROWING, State.SURGING, State.ATTACKING:
			velocity = lerp(velocity, Vector2.ZERO, 10.0 * delta)
		State.CHASING, State.TUNNELING:
			velocity = lerp(velocity, direction * speed, 8.5 * delta)

	# decisões: transições que dependem de "onde o player está agora"
	match state:
		State.IDLE:
			if is_player_in_ambush_range:
				burrow()
			elif is_player_in_chase_range:
				state = State.CHASING
		State.TUNNELING:
			if is_player_in_chase_range:
				emerge()
		State.CHASING:
			if is_player_in_attack_range:
				attack()

	move_and_slide()

# --- Transições com animação ---

# Player veio por trás: se enterra (parado) e passa a viajar por baixo
func burrow() -> void:
	state = State.BURROWING
	sprite.play("walk")
	await sprite.animation_finished
	if state == State.BURROWING:
		state = State.TUNNELING

# Chegou perto por baixo: emerge (parado) e volta à perseguição
func emerge() -> void:
	state = State.SURGING
	sprite.play("surge")
	await sprite.animation_finished
	if state == State.SURGING:
		state = State.CHASING
		sprite.play("waiting")

func attack() -> void:
	state = State.ATTACKING

	# espelha sprite E hitbox para o lado do player
	var facing_left := player.global_position.x < global_position.x
	sprite.flip_h = facing_left
	killzone_shape.position.x = -killzone_offset_x if facing_left else killzone_offset_x

	sprite.play("attack")
	await sprite.animation_finished
	killzone.monitoring = false

	await get_tree().create_timer(0.2).timeout
	if state == State.ATTACKING:
		state = State.CHASING
		sprite.play("waiting")

# --- Sensores: só traduzem física em fatos ---

func _on_chase_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_chase_range = true

func _on_chase_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_chase_range = false

func _on_ambush_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_ambush_range = true

func _on_ambush_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_ambush_range = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_attack_range = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_attack_range = false

func _on_vision_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		state = State.IDLE
		sprite.play("waiting")

# Liga a hitbox só nos frames de golpe
func _on_animated_sprite_2d_frame_changed() -> void:
	if not sprite:
		return
	
	var is_attack_frame := sprite.animation == &"attack" and sprite.frame in ATTACK_FRAMES
	killzone.monitoring = is_attack_frame
