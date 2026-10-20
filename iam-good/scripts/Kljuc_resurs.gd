extends Item_resurs
class_name  Kljuc_resurs

func use(igrac) -> void:
	UpraviteljSignala.upotrijebi_kljuc.emit(self)

func otkljucaj_vrata(_vrata : Vrata) -> bool:
	var kljuc : Kljuc_resurs = _vrata.dohvati_kljuc()
	var kljuc_pase : bool = self == kljuc
	
	if kljuc_pase:
		_vrata.otkljucaj_vrata()
	return kljuc_pase
