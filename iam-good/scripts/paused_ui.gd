extends Control
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.visible = false
	get_tree().paused = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		pauziraj_igru()

func _on_nastavi_btn_pressed() -> void:
	pauziraj_igru()

func pauziraj_igru() -> void:
	color_rect.visible = !color_rect.visible
	get_tree().paused = color_rect.visible
	if color_rect.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_menu_btn_pressed() -> void:
	get_tree().paused = false
	Upravitelj_scena.promijeni_scenu(Upravitelj_scena.menu)
