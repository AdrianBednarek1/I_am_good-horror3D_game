extends Vrata
class_name Vrata_sefa

func use() -> void:
	UpraviteljSignala.otvori_zatvori_vrata.emit(self)
