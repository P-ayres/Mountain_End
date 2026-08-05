extends Control

@onready var pause_panel = $Canvas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_hud():
	if pause_panel.visible==false:
		pause_panel.visible=true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif pause_panel.visible==true:
		pause_panel.visible=false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
