extends CharacterBody2D

@export var speed := 250.0

var seguindo = false
var midAttack = false  
var canAttack = true    # evita múltiplos ataques simultâneos
var killed = false

@onready var verme_anim: AnimatedSprite2D = $Animated
var player: CharacterBody2D

func _ready():
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if player == null:
		move_and_slide()
		return

	if not seguindo:
		velocity = lerp(velocity, Vector2.ZERO, 10.0 * delta)
	else:
		var direction = (player.global_position - global_position).normalized()
		velocity = lerp(velocity, direction * speed, 8.5 * delta)

	move_and_slide()

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguindo = true
		attack()

func _on_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguindo = false

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and not midAttack:
		verme_anim.play("walk")

func _on_catch_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguindo = true
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
	verme_anim.flip_h = sensor < 0
	await get_tree().create_timer(0.3).timeout
	verme_anim.play("surge_attack")

	#Motiroamento da área de dano
	$Area2D.monitoring = true  
	await verme_anim.animation_finished
	$Area2D.monitoring = false
	midAttack = false
	canAttack = true

	if killed:
		print("you died!")
		await get_tree().create_timer(0.3).timeout
		SceneTransition.reload_scene()

	midAttack = false
	canAttack = true
