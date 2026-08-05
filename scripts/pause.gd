extends Panel

@onready var pause_panel = $Pause

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass


func pause_hud():
	if pause_panel.visible==false:
		pause_panel.visible=true
	elif pause_panel.visible==true:
		pause_panel.visible=false
