extends Node3D
class_name Zarulja
@onready var zarulja: OmniLight3D = $OmniLight3D
@export var upaljen : bool = true

func _ready() -> void:
	zarulja.visible = upaljen

func iskljuci_ukljuci() -> void:
	if upaljen != null and zarulja != null:
		upaljen = !upaljen
		zarulja.visible = upaljen
