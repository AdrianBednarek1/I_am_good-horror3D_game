extends Button
class_name item_okvir

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var prikupljen_itemi : Array[Item_resurs]
var tip: Variant

func popuni_okvir(_prikupljen_item : Item_resurs):
	prikupljen_itemi.append(_prikupljen_item)
	if tip == null :
		tip = _prikupljen_item.get_script()
	if texture_rect.texture == null :
		texture_rect.texture = _prikupljen_item.Item_Image
	azuriraj_kolicinu()
	
func obrisi_item(id : String):
	var indeks = prikupljen_itemi.find_custom(func(_item): return _item.Id == id)
	if indeks > -1:
		prikupljen_itemi.remove_at(indeks)
	if prikupljen_itemi.size() == 0:
		queue_free()
		return
	azuriraj_kolicinu()
		
func azuriraj_kolicinu():
	if !prikupljen_itemi.back().unique:
		label.text = str(prikupljen_itemi.size())

func obrisi():
		queue_free()

func _on_pressed() -> void:
	var id = prikupljen_itemi.back().Id
	UpraviteljSignala.item_pritisnut.emit(id)

func pronadzi(id : String) -> bool:
	return prikupljen_itemi.any(func(item): return item.Id == id)

func dohvati_naziv() -> String:
	return prikupljen_itemi.back().Name
