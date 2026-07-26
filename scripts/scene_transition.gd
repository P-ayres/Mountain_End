extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_in_transition: bool = false;

func _ready() -> void:
	process_mode =Node.PROCESS_MODE_ALWAYS

func change_scene(scene):
	if(is_in_transition):
		return
	
	print("tentando trocar pra cena: '%s'" % scene) 
	is_in_transition = true
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().call_deferred("change_scene_to_file", scene)
	animation_player.play("fade_out")
	await animation_player.animation_finished
	is_in_transition = false
	

func reload_scene():
	print("itens (before reload): %s" % [", ".join(GameSystem.item)])
	
	# seta teu spawn point para onde tu iniciou pela ultima vez
	GameSystem.next_room_position = GameSystem.current_room_spawn
	# remove itens que tu pegou antes de sair da sala 
	# Ex. abriu o bau e morreu, perdeu a chave
	GameSystem.item = GameSystem.current_room_item
	
	print("itens (after reload): %s" % [", ".join(GameSystem.item)])
	await change_scene(get_tree().current_scene.scene_file_path)
	GameSystem.pause_game()
