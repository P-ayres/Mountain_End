extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $KillzoneArea
@onready var killzone_shape: CollisionShape2D = $KillzoneArea/CollisionShape2D

@export var speed := 250.0

enum State {IDLE, TUNNELING, ATTACKING, BURROWING}
const ATTACK_FRAMES := [1, 2, 3] # emersão com a boca pra cima

var state := State.IDLE
var player: CharacterBody2D
var is_player_in_attack_range := false
var is_chasing := false
var is_hunt_forced := false # a fase mandou caçar, ver scripts/hunt_trigger.gd
var killzone_offset_x := 0.0 # posição original da hitbox, usado ao espelhar


func _ready():
	killzone.monitoring = false
	killzone_offset_x = killzone_shape.position.x

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
		State.IDLE, State.ATTACKING, State.BURROWING:
			velocity = lerp(velocity, Vector2.ZERO, 10.0 * delta)
		State.TUNNELING:
			velocity = lerp(velocity, direction * speed, 8.5 * delta)

	match state:
		State.IDLE:
			if is_player_in_attack_range:
				attack()
			elif _should_chase():
				state = State.TUNNELING
				sprite.play("walk")
		State.TUNNELING:
			if is_player_in_attack_range:
				attack()

	move_and_slide()

func attack() -> void:
	state = State.ATTACKING

	var facing_left := player.global_position.x < global_position.x
	sprite.flip_h = facing_left
	killzone_shape.position.x = - killzone_offset_x if facing_left else killzone_offset_x

	sprite.play("surge_attack")
	await sprite.animation_finished
	killzone.monitoring = false

	if state == State.ATTACKING:
		burrow()

func burrow() -> void:
	state = State.BURROWING
	sprite.play_backwards("surge_attack") # nao existe animação para voltar para terra, então roda a animação se emergir ao contrario
	await sprite.animation_finished

	await get_tree().create_timer(0.2).timeout

	if state == State.BURROWING:
		state = State.TUNNELING if _should_chase() else State.IDLE
		sprite.play("walk")

# persegue por conta própria (ChaseArea) ou porque a fase mandou (HuntTrigger)
func _should_chase() -> bool:
	return is_chasing or is_hunt_forced

func _on_chase_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_chasing = true

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_attack_range = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_attack_range = false

func _on_vision_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return

	if state == State.ATTACKING or state == State.BURROWING:
		return

	if is_hunt_forced:
		return

	if is_chasing:
		is_chasing = false;

	state = State.IDLE
	sprite.play("walk")

func _on_animated_sprite_2d_frame_changed() -> void:
	if not sprite:
		return

	var is_attack_frame := state == State.ATTACKING \
		and sprite.animation == &"surge_attack" \
		and sprite.frame in ATTACK_FRAMES

	killzone.monitoring = is_attack_frame

func set_hunt_forced(value: bool) -> void:
	is_hunt_forced = value
