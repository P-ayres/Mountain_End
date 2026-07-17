extends CharacterBody2D

@export var speed := 250.0

var seguindo = false
var em_animacao = false

@onready var vermeAnimation: AnimatedSprite2D = $Animated
@onready var player: CharacterBody2D = get_parent().get_node("player")

	
func _physics_process(delta: float) -> void:
	if seguindo:
		var direction = (player.global_position-global_position).normalized()
		velocity = lerp(velocity, direction * speed, 8.5*delta)
		move_and_slide()


func _on_activation_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguindo = true
		attack()



func _on_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguindo = false

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		vermeAnimation.play("walk")


func _on_catch_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		seguindo = true
		attack()
	

func attack():
	var sensor = player.global_position.x - global_position.x
	vermeAnimation.flip_h = sensor < 0
	await get_tree().create_timer(0.3).timeout
	vermeAnimation.play("surge_attack")
	em_animacao = true
	await vermeAnimation.animation_finished
	em_animacao = false
	
