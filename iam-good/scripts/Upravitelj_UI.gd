extends Control

var slika_jump_scare_ui: Control 
var item_pregledUI: Control 
var inventarUI: Control 
var obavjestUI: Control
var pin_ui: Control 

var protivnik_proganja : bool = false
var otvorena_slika : Slika
var kod : Node3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	UpraviteljSignala.connect("inventory", pritisnut_inventar)
	UpraviteljSignala.connect("prikazi_item", prikazi_item)
	UpraviteljSignala.connect("makni_inventory", makni_inventory)
	UpraviteljSignala.connect("postavi_mis", postavi_mis)
	UpraviteljSignala.connect("item_collected", dodaj_item)
	UpraviteljSignala.connect("maknut_item", maknut_item)
	UpraviteljSignala.connect("protivnik_proganja", protivnik_proganja_igraca)
	UpraviteljSignala.connect("prikazi_pin", prikazi_kod_UI)
	UpraviteljSignala.connect("pin_upisan", pin_upisan)
	UpraviteljSignala.connect("esc_pritisnut", esc_pritisnut)
	UpraviteljSignala.connect("interakcija_slika", prikazi_sliku)
	UpraviteljSignala.connect("jump_scare", jump_scare)
	UpraviteljSignala.connect("pickable", prikazi_interakciju)
	UpraviteljSignala.connect("otkljucavanje_vrata", otkljucavanje_vrata)
	UpraviteljSignala.connect("ulovio_igraca", makni_inventory)
	UpraviteljSignala.connect("vrata_otkljucana", prikazi_vrata_otkljucana)
	
func inicijalizacija(_item_pregledUI : Control, _inventarUI : Control, _obavjestUI : Control, _pin_ui: Control, _slika_jump_scare_ui : Control) -> void:
	slika_jump_scare_ui = _slika_jump_scare_ui
	item_pregledUI = _item_pregledUI
	inventarUI = _inventarUI
	obavjestUI = _obavjestUI
	pin_ui = _pin_ui

func dodaj_item(item: Item_resurs) -> void:
	inventarUI.dodaj_item(item)
	if item is Papir_resurs:
		obavjestUI.dodaj_bod()

func prikazi_vrata_otkljucana(vrata : Vrata) ->  void:
	obavjestUI.prikazi_vrata_otkljucana()

func prikazi_interakciju(prikazi : bool)-> void:
	obavjestUI.prikazi_interakciju(prikazi)

func maknut_item(id : String) -> void:
	inventarUI.makni_item(id)

func makni_inventory() -> void:
	inventarUI.sakrij_inventar()
	postavi_mis()
	var sav_ui_skriven : bool = skriven_ui()
	UpraviteljSignala.sav_ui_skriven.emit(sav_ui_skriven)

func pritisnut_inventar() -> void:
	if skriveno_osim_inventara_ui():
		inventarUI.otvori_zatvori()
	
	var sakrij_inventar : bool = false
	sakrij_ui(sakrij_inventar)

func prikazi_item(item : Item_resurs) -> void:
	inventarUI.sakrij_inventar()
	item_pregledUI.prikazi_item(item)
	
func otkljucavanje_vrata(vrata : Okvir_vrata):
	if !protivnik_proganja:
		pritisnut_inventar()

func skriveno_osim_inventara_ui() -> bool:
	var sve_skriveno : bool = !item_pregledUI.item_otvoren() and !pin_ui.pin_ui_vidljiv() and !slika_jump_scare_ui.slika_vidljiv()
	return sve_skriveno

func skriven_ui() -> bool:
	var sve_skriveno : bool = !inventarUI.inventar_otvoren() and !item_pregledUI.item_otvoren() and !pin_ui.pin_ui_vidljiv() and !slika_jump_scare_ui.slika_vidljiv()
	return sve_skriveno
	
func protivnik_proganja_igraca(proganja_igraca : bool) -> void:
	obavjestUI.prikazi_upozorenje(proganja_igraca)
	protivnik_proganja = proganja_igraca
	var sakrij_inventar_ako_proganja : bool = proganja_igraca
	sakrij_ui(sakrij_inventar_ako_proganja)
	
func postavi_mis() -> void:
	var sav_ui_skriven : bool = skriven_ui()
	if sav_ui_skriven:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func prikazi_kod_UI(_kod : Node3D) -> void:
	if protivnik_proganja:
		return
	pin_ui.prikazi_pin_ui()
	kod = _kod
	postavi_mis()
	var sav_ui_skriven : bool = skriven_ui()
	UpraviteljSignala.sav_ui_skriven.emit(sav_ui_skriven)

func pin_upisan(_pin : String) -> void:
	if !kod:
		return
	var pin_ispravan : bool = kod.upisi_pin(_pin)
	if !pin_ispravan:
		return
	pin_ui.sakrij_pin_ui()
	kod = null
	postavi_mis()
	var sav_ui_skriven : bool = skriven_ui()
	UpraviteljSignala.sav_ui_skriven.emit(sav_ui_skriven)
		
func sakrij_ui(inventar_sakriti : bool) -> void:
	if inventar_sakriti:
		inventarUI.sakrij_inventar()
	item_pregledUI.sakrij_item()
	pin_ui.sakrij_pin_ui()
	slika_jump_scare_ui.makni_sliku()
	postavi_mis()
	var sav_ui_skriven : bool = skriven_ui()
	UpraviteljSignala.sav_ui_skriven.emit(sav_ui_skriven)
	
func esc_pritisnut() -> void:
	var sakrij_inventar : bool = true
	sakrij_ui(sakrij_inventar)
	
func prikazi_sliku(_slika : Slika, _postoji_jumpscare : bool) -> void:
	if protivnik_proganja:
		return
	slika_jump_scare_ui.prikazi_sliku(_slika.trenutna_slika)
	if _postoji_jumpscare != null:
		otvorena_slika = _slika
		slika_jump_scare_ui.jump_scare(_slika.iduca_slika)
	var sav_ui_skriven : bool = skriven_ui()
	UpraviteljSignala.sav_ui_skriven.emit(sav_ui_skriven)
	
func jump_scare() -> void:
	item_pregledUI.sakrij_item()
	inventarUI.sakrij_inventar()
	pin_ui.sakrij_pin_ui()
	postavi_mis()
	var sav_ui_skriven : bool = skriven_ui()
	otvorena_slika.promjena_slike()
	otvorena_slika = null
	UpraviteljSignala.sav_ui_skriven.emit(sav_ui_skriven)
