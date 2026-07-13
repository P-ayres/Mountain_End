extends PanelContainer

@export var prompt_text: String = ""

@onready var label: Label = $MarginContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var key: String = _get_key_text("interact")
	var text: String = (" %s" % [prompt_text]) if !prompt_text.is_empty() else ""

	visible = false
	label.text = "[%s]%s" % [key, text]

	# espera o layout calcular o tamanho final antes de centralizar
	await get_tree().process_frame
	_recenter()

# Empurra o inicio da horizontal caixinha de texto para a esquerda.
# Esse cálculo considera metade do tamanho dela (margens + conteúdo)
func _recenter() -> void:
	position.x = -size.x / 2.0

func show_prompt() -> void:
	visible = true

func hide_prompt() -> void:
	visible = false

func _get_key_text(action: String) -> String:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			return OS.get_keycode_string(event.physical_keycode)

	return "?"
