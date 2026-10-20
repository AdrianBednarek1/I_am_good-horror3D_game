extends Control
@onready var color_rect: ColorRect = $ColorRect
@onready var texture_rect: TextureRect = $ColorRect/MarginContainer/VBoxContainer/TextureRect
@onready var label: Label = $ColorRect/MarginContainer/VBoxContainer/Label

func prikazi_item(item : Item_resurs) -> void:
	if item_otvoren():
		return
	label.text = item.tekst
	texture_rect.texture = item.Item_Image
	color_rect.visible = true

func sakrij_item() -> void:
	if item_otvoren():
		color_rect.visible = false

func item_otvoren() -> bool:
	return color_rect.visible
