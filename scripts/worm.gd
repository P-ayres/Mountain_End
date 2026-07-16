extends CharacterBody2D

@export var speed := 120.0
@export var dist_parar := 40.0
var seguindo = false
var primeira_vez_vendo = true
var em_animacao = false
@onready var vermeAnimation: AnimatedSprite2D = $Animated

var player: CharacterBody2D

var gravidade: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravidade * delta
	
	if player == null:
		move_and_slide()
		return
	
	if em_animacao: 
		return
	
	if seguindo:
		var direcaoPlayer = player.global_position.x - global_position.x
		var distancia = abs(direcaoPlayer)
		
		if distancia > dist_parar:
			
			var lado = sign(direcaoPlayer)
			velocity.x = lado * speed
			vermeAnimation.flip_h = direcaoPlayer > 0
			vermeAnimation.play("walk")
			
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


func _on_vision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguindo = true
		
		var direcaoPlayer = player.global_position.x - global_position.x
		if primeira_vez_vendo:
			vermeAnimation.flip_h = direcaoPlayer > 0
			vermeAnimation.play("apparition")
			
			em_animacao = true
			await vermeAnimation.animation_finished
			em_animacao = false
			primeira_vez_vendo = false

func _on_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguindo = false
