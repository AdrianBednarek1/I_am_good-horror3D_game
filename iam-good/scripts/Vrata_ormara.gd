extends Vrata
class_name Vrata_ormara

func use() -> void:
	UpraviteljSignala.otvori_zatvori_vrata.emit(self)
