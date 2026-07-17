extends CharacterBody2D

@export var speed := 120.0
@export var velocidadeDeRotacao := 50.0
@export var gravidade := 800

const distanciaMinima := 10.0

var seguindo = false
var primeira_vez_vendo = true
var em_animacao = false

@onready var vermeAnimation: AnimatedSprite2D = $Animated
@onready var navegacaoVerme: NavigationAgent2D= $NavigationAgent2D
@onready var verificaSuperficie: RayCast2D = $RayCast2D

var player: CharacterBody2D

func _ready():
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")
	if player:
		navegacaoVerme.target_position = player.global_position
	
func _physics_process(delta):
	
	if player == null:
		move_and_slide()
		return
	
	if em_animacao: 
		return
	
	if seguindo:
		if navegacaoVerme.target_position.distance_squared_to(player.global_position) > distanciaMinima * distanciaMinima:
			navegacaoVerme.target_position = player.global_position

		if not navegacaoVerme.is_navigation_finished():
			var destino = navegacaoVerme.get_next_path_position()
			var direcaoPlayer = global_position.direction_to(destino)
			var cima = -global_transform.y
			var direcaoParaCriatura = direcaoPlayer.slide(cima).normalized()
			var enemyVelocity = direcaoParaCriatura * speed
			var sensor = direcaoParaCriatura.dot(global_transform.x)
			vermeAnimation.flip_h = sensor > 0
			vermeAnimation.play("walk")

			var alvo = global_position - cima * velocidadeDeRotacao
			verificaSuperficie.target_position = verificaSuperficie.to_local(alvo)
			verificaSuperficie.force_raycast_update()
			var orientacao = cima
			if verificaSuperficie.is_colliding():
				orientacao = verificaSuperficie.get_collision_normal()

			var direcao = cima.lerp(orientacao, velocidadeDeRotacao * delta).normalized()
			var lado = Vector2(direcao.y, -direcao.x)
			global_transform = Transform2D(lado, -direcao, global_position)
			velocity = enemyVelocity
			velocity += -direcao * gravidade * delta
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			if primeira_vez_vendo:
				vermeAnimation.play("floor")
			else:
				vermeAnimation.play("stop")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if primeira_vez_vendo:
			vermeAnimation.play("floor")
		else:
			vermeAnimation.play("stop")

	move_and_slide()


func _on_activation_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguindo = true
		
		var sensor = player.global_position.x - global_position.x
		if primeira_vez_vendo:
			vermeAnimation.flip_h = sensor < 0
			vermeAnimation.play("apparition")
			
			em_animacao = true
			await vermeAnimation.animation_finished
			em_animacao = false
			primeira_vez_vendo = false

func _on_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguindo = false
