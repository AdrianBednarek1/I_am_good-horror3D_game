extends Interaktivni_objekt
class_name Vrata
var kljuc : Kljuc_resurs

func use() -> void:
	UpraviteljSignala.otvori_zatvori_vrata.emit(self)

func dohvati_kljuc() -> Kljuc_resurs:
	return kljuc

func postavi_kljuc(_kljuc : Kljuc_resurs) -> void:
	kljuc = _kljuc

func otkljucaj_vrata() -> void:
	UpraviteljSignala.vrata_otkljucana.emit(self)
