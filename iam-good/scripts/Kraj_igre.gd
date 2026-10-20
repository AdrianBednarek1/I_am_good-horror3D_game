extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_menu_btn_pressed() -> void:
	Upravitelj_scena.promijeni_scenu(Upravitelj_scena.menu)
