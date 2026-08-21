extends MenuButton


func _ready():
	get_popup().add_item("English")
	get_popup().set_item_metadata(0, "en_US")

	get_popup().add_item("Português")
	get_popup().set_item_metadata(1, "pt_BR")

	get_popup().id_pressed.connect(_on_language_selected)
	add_child(get_popup())

func _on_language_selected(id: int):
	var locale: String = get_popup().get_item_metadata(id)
	TranslationServer.set_locale(locale)
