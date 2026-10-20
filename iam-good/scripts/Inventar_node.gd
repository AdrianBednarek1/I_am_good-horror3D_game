extends Node
class_name Inventar 

var stvari : Dictionary[String, Item_resurs] = {}

func dodaj(stvar : Item_resurs)->void:
	stvari.get_or_add(stvar.Id, stvar)

func obrisi(stvar_id: String)->void:
	stvari.erase(stvar_id)
	
func dohvati(stvar_id: String) -> Item_resurs:
	return stvari.get(stvar_id)

func dohvati_sve() -> Dictionary[String, Item_resurs]:
	return stvari
