extends CharacterBody2D

@onready var wormAnimation: AnimatedSprite2D = $Animated
@onready var killzone: Area2D = $Area2D

@export var speed := 250.0

var following = false
var midAttack = false
var canAttack = true    # evita múltiplos ataques simultâneos
var killed = false
var player: CharacterBody2D


func _ready():
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if GameSystem.current_state != GameSystem.GameState.PLAYING:
		return

	if player == null:
		move_and_slide()
		return

	if not following:
		velocity = lerp(velocity, Vector2.ZERO, 10.0 * delta)
	else:
		var direction = (player.global_position - global_position).normalized()
		velocity = lerp(velocity, direction * speed, 8.5 * delta)

	move_and_slide()

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		following = true
		attack()

func _on_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		following = false

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		wormAnimation.play("walk")

func _on_catch_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		following = true
		attack()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		killed = true

func attack():
	if not canAttack:
		return

	#controladores de ataque
	canAttack = false
	midAttack = true
	killed = false

	var sensor = player.global_position.x - global_position.x
	wormAnimation.flip_h = sensor < 0
	await get_tree().create_timer(0.3).timeout
	wormAnimation.play("surge_attack")

	#Motiroamento da área de dano
	killzone.monitoring = true
	await wormAnimation.animation_finished
	killzone.monitoring = false
	midAttack = false
	canAttack = true

	if killed:
		GameSystem.pause_game()
		print("you died!")
		SfxManager.play_sfx("Kill") 
		SceneTransition.reload_scene()
		await SceneTransition.animation_player.animation_finished
		GameSystem.pause_game()
		
