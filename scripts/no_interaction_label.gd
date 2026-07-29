extends PanelContainer

@onready var label: Label = $MarginContainer/Label

@export var text: String = ""


func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	_recenter()

func show_message(prompt_text):
	label.text = prompt_text
	
	show_prompt()
	await get_tree().create_timer(3).timeout
	hide_prompt()

func _recenter() -> void:
	position.x = -size.x / 2.0

func show_prompt() -> void:
	visible = true

func hide_prompt() -> void:
	visible = false
