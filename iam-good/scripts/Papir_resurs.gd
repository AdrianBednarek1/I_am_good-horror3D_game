extends Item_resurs
class_name Papir_resurs

@export var tekst : String

func use(player : CharacterBody3D)->void:
	UpraviteljSignala.prikazi_item.emit(self)
