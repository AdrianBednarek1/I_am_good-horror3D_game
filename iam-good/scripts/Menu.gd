extends Control

@onready var postavke_ui: Control = $ColorRect/Postavke_UI
@onready var menu_children: VBoxContainer = $ColorRect/MenuChildren

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_play_btn_pressed() -> void:
	Upravitelj_scena.promijeni_scenu(Upravitelj_scena.level1)

func _on_quit_btn_pressed() -> void:
	Upravitelj_scena.quit()
	
func _on_settings_btn_pressed() -> void:
	menu_children.visible = false
	postavke_ui.visible = true

func _on_postavke_ui_hidden() -> void:
	menu_children.visible = true
