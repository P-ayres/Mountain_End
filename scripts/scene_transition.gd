extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_in_transition: bool = false;


func change_scene(scene):
	if(is_in_transition):
		return
	
	is_in_transition = true
	GameSystem.pause_game()
	animation_player.play("fade_in")
	if scene == "reset":
		await animation_player.animation_finished
		reload_scene()
	else:
		await animation_player.animation_finished
		get_tree().change_scene_to_file(scene)

	GameSystem.pause_game()
	animation_player.play("fade_out")
	await animation_player.animation_finished
	is_in_transition = false

func reload_scene():
	print("itens (before reload): %s" % [", ".join(GameSystem.item)])
	
	GameSystem.next_room_position = GameSystem.current_room_spawn
	GameSystem.item = GameSystem.current_room_item
	
	print("itens (after reload): %s" % [", ".join(GameSystem.item)])
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
