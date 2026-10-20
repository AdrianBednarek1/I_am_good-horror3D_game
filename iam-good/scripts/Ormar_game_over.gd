extends Node3D
@onready var ormar: Ormar = $ormar
@onready var upravitelj: Node = $Upravitelj

func _ready() -> void:
	upravitelj.inicijalizacija(ormar)
	UpraviteljSignala.connect("kraj_igre", animacija_zavrsena)

func animacija_zavrsena(scena: String) -> void:
	Upravitelj_scena.promijeni_scenu(scena)
