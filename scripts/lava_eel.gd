extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $KillzoneArea

@export var speed := 250.0

const ATTACK_FRAMES := [3, 4]	# frames com hitbox ativa

var following = false
#var midAttack = false
var canAttack = true	# evita múltiplos ataques simultâneos
var player: CharacterBody2D
#var killed = false


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

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		following = true
		attack()

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		sprite.play("walk")

func _on_vision_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		following = false

#func _on_catch_area_body_entered(body: Node2D) -> void:
#	if body.is_in_group("Player"):
#		following = true
#		attack()

#func _on_area_2d_body_entered(body: Node2D) -> void:
#	if body.is_in_group("Player"):
#		killed = true

func attack():
	if not canAttack:
		return

	#controladores de ataque
	canAttack = false
	#midAttack = true
	#killed = false

	var sensor = player.global_position.x - global_position.x
	sprite.flip_h = sensor < 0
	await get_tree().create_timer(0.3).timeout
	sprite.play("tail_attack")

	await sprite.animation_finished
	killzone.monitoring = false
	
	#midAttack = false
	
	# 500ms sem poder atacar novamente
	await get_tree().create_timer(0.5).timeout
	canAttack = true

	#if killed:
	#	GameSystem.pause_game()
	#	print("you died!")
	#	SceneTransition.reload_scene()
	#	await SceneTransition.animation_player.animation_finished
	#	GameSystem.pause_game()
		


#Motiroamento da área de dano
func _on_animated_sprite_2d_frame_changed() -> void:
	var em_janela_de_dano = sprite.animation == "tail_attack" and sprite.frame in ATTACK_FRAMES
	killzone.monitoring = em_janela_de_dano
