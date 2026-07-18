extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $KillzoneArea

@export var speed := 250.0

const ATTACK_FRAMES := [3, 4]	# frames com hitbox ativa

var following = false
var canAttack = true	# evita múltiplos ataques simultâneos
var player: CharacterBody2D


func _ready():
	killzone.monitoring = false
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if player == null:
		move_and_slide()
		return

	if not following:
		velocity = lerp(velocity, Vector2.ZERO, 10.0 * delta)
	else:
		var direction = (player.global_position - global_position).normalized()
		velocity = lerp(velocity, direction * speed, 8.5 * delta)

	move_and_slide()

# Inicia a perseguição ao player
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player entered on attack area, attack!")
		following = true
		attack()

# Troca a animação para "caminhar", ao sair da area de ataque
func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player exited attack area, walk!")
		sprite.play("walk")

# Saiu do ccampo de visão, para de seguir o jogador
func _on_vision_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player exited vision area, stay!")
		following = false

# Só monitora se colidiu nos frames de ataque
func _on_animated_sprite_2d_frame_changed() -> void:
	if not sprite:
		return
	
	var em_janela_de_dano = sprite.animation == &"tail_attack" and sprite.frame in ATTACK_FRAMES
	killzone.monitoring = em_janela_de_dano

func _on_catch_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player entered on catch area, attack!")
		following = true
		attack()

func attack():
	if not canAttack:
		return

	canAttack = false

	var sensor = player.global_position.x - global_position.x
	sprite.flip_h = sensor < 0

	await get_tree().create_timer(0.3).timeout
	sprite.play("tail_attack")

	await sprite.animation_finished
	killzone.monitoring = false
	
	# 200ms sem poder atacar novamente
	await get_tree().create_timer(0.2).timeout
	canAttack = true		
