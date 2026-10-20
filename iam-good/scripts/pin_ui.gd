extends Control
@onready var pin_ekran: Label = $PanelContainer/MarginContainer/VBoxContainer/ekran/pin_ekran
@onready var panel_container: PanelContainer = $PanelContainer

func _ready() -> void:
	panel_container.visible = false
	
func moze_upisati() -> bool:
	return pin_ekran.text.length()<4
	
func _1_btn_pressed() -> void:
	if moze_upisati():
		pin_ekran.text += "1"

func _2_btn_pressed() -> void:
	if moze_upisati():
		pin_ekran.text += "2"

func _3_btn_pressed() -> void:
	if moze_upisati():
		pin_ekran.text += "3"

func _4_btn_pressed() -> void:
	if moze_upisati():
		pin_ekran.text += "4"

func _5_btn_pressed() -> void:
	if moze_upisati():
		pin_ekran.text += "5"

func _6_btn_pressed() -> void:
	if moze_upisati():
		pin_ekran.text += "6"

func _7_btn_pressed() -> void:
	if moze_upisati():
		pin_ekran.text += "7"

func _8_btn_pressed() -> void:
	if moze_upisati():
		pin_ekran.text += "8"

func _9_btn_pressed() -> void:
	if moze_upisati():
		pin_ekran.text += "9"

func _obrisi_btn_pressed() -> void:
	if !pin_ekran.text.is_empty():
		pin_ekran.text = pin_ekran.text.left(pin_ekran.text.length() - 1)

func _unesi_btn_pressed() -> void:
	UpraviteljSignala.pin_upisan.emit(pin_ekran.text)
	
func pin_ui_vidljiv() -> bool:
	return panel_container.visible

func sakrij_pin_ui() -> void:
	if panel_container.visible:
		pin_ekran.text = ""
		panel_container.visible = false
		
func prikazi_pin_ui() -> void:
	if !panel_container.visible:
		panel_container.visible = true
