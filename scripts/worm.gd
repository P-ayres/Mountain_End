extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $KillzoneArea
@onready var killzone_shape: CollisionShape2D = $KillzoneArea/CollisionShape2D

@export var speed := 250.0

enum State {SURFACED, CHASING, ATTACKING}
const ATTACK_FRAMES := [1, 2, 3]
const SURGE_ANIM := &"surge_attack"

var state := State.SURFACED
var player: CharacterBody2D
var is_player_in_attack_range := false
var is_chasing := false
var is_hunt_forced := false
var is_submerged := false
var killzone_offset_x := 0.0


func _ready():
	killzone.monitoring = false
	killzone_offset_x = killzone_shape.position.x
	_show_surfaced()

	await get_tree().process_frame

	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if GameSystem.current_state != GameSystem.GameState.PLAYING:
		return

	if player == null:
		move_and_slide()
		return

	var direction = (player.global_position - global_position).normalized()

	# movimento: cada estado declara o seu (anda até enquanto entra/sai da terra)
	match state:
		State.SURFACED, State.ATTACKING:
			velocity = lerp(velocity, Vector2.ZERO, 10.0 * delta)
		State.CHASING:
			velocity = lerp(velocity, direction * speed, 8.5 * delta)

	# decisões: transições que dependem de "onde o player está agora"
	match state:
		State.SURFACED:
			if is_player_in_attack_range:
				attack()
			elif _should_chase():
				state = State.CHASING
				_sync_burrow_pose()
		State.CHASING:
			if is_player_in_attack_range:
				attack()
			elif not _should_chase():
				state = State.SURFACED
				if is_submerged:
					sprite.play(SURGE_ANIM)

	move_and_slide()

# --- Transições com animação ---

# Player está no alcance de golpe: ataca de onde estiver (visível ou escondida)
func attack() -> void:
	state = State.ATTACKING

	# espelha sprite E hitbox para o lado do player
	var facing_left := player.global_position.x < global_position.x
	sprite.flip_h = facing_left
	killzone_shape.position.x = - killzone_offset_x if facing_left else killzone_offset_x

	sprite.play(SURGE_ANIM)
	await sprite.animation_finished
	killzone.monitoring = false

	if state != State.ATTACKING:
		return

	# a animação já termina totalmente emergida
	if _should_chase():
		state = State.CHASING
		_sync_burrow_pose()
	else:
		state = State.SURFACED

# Acompanha a SubmergeArea: entra na terra se o player está dentro dela, sai se não
func _sync_burrow_pose() -> void:
	if is_submerged:
		sprite.play_backwards(SURGE_ANIM)
	else:
		sprite.play(SURGE_ANIM)

# Pose de repouso: não existe animação de idle, então segura o último frame do surge
func _show_surfaced() -> void:
	sprite.animation = SURGE_ANIM
	sprite.set_frame_and_progress(sprite.sprite_frames.get_frame_count(SURGE_ANIM) - 1, 1.0)
	sprite.pause()

func _should_chase() -> bool:
	return is_chasing or is_hunt_forced

# --- Sensores: só traduzem física em fatos ---

func _on_chase_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_chasing = true

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_attack_range = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_in_attack_range = false

func _on_submerge_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return

	is_submerged = true
	if state == State.CHASING:
		_sync_burrow_pose()

func _on_submerge_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return

	is_submerged = false
	if state == State.CHASING:
		_sync_burrow_pose()

func _on_vision_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return

	if is_hunt_forced:
		return

	is_chasing = false

func _on_animated_sprite_2d_frame_changed() -> void:
	if not sprite:
		return

	var is_attack_frame := state == State.ATTACKING \
		and sprite.animation == SURGE_ANIM \
		and sprite.frame in ATTACK_FRAMES

	killzone.monitoring = is_attack_frame

func set_hunt_forced(value: bool) -> void:
	is_hunt_forced = value
