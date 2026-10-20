extends Control

@onready var option_button: OptionButton = $PanelContainer/MarginContainer/Container/OptionButton
enum prikaz_ekrana {WINDOWED = 0, MINIMIZED = 1, MAXIMIZED = 2, FULLSCREEN = 3}

func _on_menu_btn_pressed() -> void:
	self.visible = false

func _ready() -> void:
	self.visible = false
	option_button.select(DisplayServer.window_get_mode())

func _on_option_button_item_selected(index: int) -> void:
	match index:
		prikaz_ekrana.WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			return
		prikaz_ekrana.MINIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
			return
		prikaz_ekrana.MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			return
		prikaz_ekrana.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			return
