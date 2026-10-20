extends Node
var ormar : Node3D

func _ready() -> void:
	UpraviteljSignala.connect("animacija_zavrsila", animacija_zavrsila)

func inicijalizacija(_ormar : Node3D) -> void:
	ormar = _ormar
	pokreni_ormar_animaciju()

func pokreni_ormar_animaciju() -> void:
	if ormar == null:
		return
	ormar.otvori_polagano_ormar()

func animacija_zavrsila(ormar : Ormar) ->void:
	UpraviteljSignala.kraj_igre.emit(Upravitelj_scena.game_over)
