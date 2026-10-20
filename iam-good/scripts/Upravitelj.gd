extends Node
class_name Upravitelj

var igrac : CharacterBody3D
var protivnik : CharacterBody3D
var izlaz_iz_levela : StaticBody3D
var kamera_pocetna : Camera3D

var vidi_igraca_ormar : bool = false
var u_ormaru : bool = false
var bodovi : int = 0
var ukupni_bodovi : int = 0

var trokut_putanja: Node3D
var aktivni_trokut: Trokut_resurs
var trokut_nav_agent: NavigationAgent3D

var ucestalost : float = 0
var povecanje : bool = false
var iduca_boja : Color = Color.RED
var pocetna_boja : Color = Color.WHITE
var update : float = 0

@export var pod_materijal: StandardMaterial3D
@export var interval : float = 0.3

func _ready() -> void:
	UpraviteljSignala.connect("oko_pritisnuto", oko_pritisnuto)
	UpraviteljSignala.connect("ormar_usao_izasao", ormar_usao_izasao)
	UpraviteljSignala.connect("animacija_zavrsila", ormar_zatvoren)
	UpraviteljSignala.connect("protivnik_vidi_igraca", protivnik_vidi_igraca)
	UpraviteljSignala.connect("ulovio_igraca", ulovio_igraca)
	UpraviteljSignala.connect("protivnik_proganja", protivnik_proganja_igraca)
	UpraviteljSignala.connect("sav_ui_skriven", skriven_ui_moze_kretati)
	UpraviteljSignala.connect("item_collected", item_collected)
	UpraviteljSignala.connect("upotrijebi_kljuc", upotrijebi_kljuc)
	UpraviteljSignala.connect("trokut_pritisnut", trokut_pritisnut)
	
func inicijalizacija(_igrac : CharacterBody3D, _protivnik : CharacterBody3D, _izlaz_iz_levela : StaticBody3D, _papiri : Node3D, _pocetna_scena : Camera3D) -> void:
	igrac = _igrac
	protivnik = _protivnik
	izlaz_iz_levela = _izlaz_iz_levela
	ukupni_bodovi = _papiri.get_child_count()
	kamera_pocetna = _pocetna_scena
	kamera_pocetna.connect("pocetna_scena_zavrsena", pocetna_scena_zavrsena)
	pokreni_pocetnu_scenu()
	izlaz_iz_levela.zakljucaj_vrata()

func _process(delta: float) -> void:
	if ukupni_bodovi == bodovi:
		promjena_boje_materijala(delta)
	
	update += delta
	if trokut_putanja != null and update >= interval:
		aktivni_trokut.azuriraj_putanju(protivnik.dohvati_navigation_agent(),trokut_putanja)
		update = 0
		
func pokreni_pocetnu_scenu() -> void:
	igrac.zauzet = true
	igrac.moze_kretati = false
	kamera_pocetna.make_current()
	kamera_pocetna.odigraj_animaciju()
	
func pocetna_scena_zavrsena() -> void:
	igrac.zauzet = false
	igrac.moze_kretati = true
	var kamera = igrac.vrati_kameru()
	kamera.make_current()
	
func upotrijebi_kljuc(_kljuc : Kljuc_resurs) -> void:
	var vrata = igrac.dohvati_koliziju()
	var vrata_otkljucana : bool = false
	if vrata is Vrata:
		vrata_otkljucana = _kljuc.otkljucaj_vrata(vrata)
	if vrata_otkljucana:
		igrac.makni_sa_inventara(_kljuc.Id)
	makni_inventory()
		
func ormar_zatvoren(ormar : Ormar) -> void:
	if !protivnik.proganja_igraca:
		return
	if vidi_igraca_ormar:
		return
	protivnik.postavi_proganja_igraca(false)
	
func makni_inventory() -> void:
	UpraviteljSignala.makni_inventory.emit()
	
func oko_pritisnuto(oko : Oko_resurs) -> void:
	makni_inventory()
	igrac.makni_sa_inventara(oko.Id)
	await oko.aktiviraj_oko(igrac, protivnik)
	
func trokut_pritisnut(trokut: Trokut_resurs) -> void:
	makni_inventory()
	
	if aktivni_trokut != null:
		return
		
	var trokut_nav_agent = protivnik.dohvati_navigation_agent()
	aktivni_trokut = trokut
	igrac.makni_sa_inventara(trokut.Id)
	trokut_putanja = trokut.napravi_putanju(trokut_nav_agent)
	get_tree().current_scene.add_child(trokut_putanja)
	await trokut.pokreni_timer(trokut_nav_agent)
	trokut_putanja.queue_free()
	trokut_putanja = null
	aktivni_trokut = null
	
func ormar_usao_izasao(ormar : Ormar, _u_ormaru : bool) -> void:
	u_ormaru = _u_ormaru
	if !u_ormaru:
		protivnik.treba_javiti = false
		return
	if !protivnik.proganja_igraca:
		return
	protivnik.treba_javiti = true

func item_collected(item : Item_resurs) -> void:
	if bodovi == ukupni_bodovi:
		return
	if item is Papir_resurs:
		bodovi = bodovi + 1
	if bodovi == ukupni_bodovi:
		izlaz_iz_levela.otkljucaj_vrata()
		izlaz_iz_levela.otvori_vrata()
		UpraviteljSignala.izlaz_otvoren.emit()

func ulovio_igraca() -> void:
	if u_ormaru:
		ulovio_igraca_u_ormaru()
		return
	protivnik.camera.make_current()
	protivnik.rotiraj_kameru()
	protivnik.moze_zumirati = true
	igrac.queue_free()
	await get_tree().create_timer(3).timeout
	UpraviteljSignala.kraj_igre.emit(Upravitelj_scena.game_over)

func ulovio_igraca_u_ormaru() -> void:
	UpraviteljSignala.kraj_igre.emit(Upravitelj_scena.ormar_game_over)

func protivnik_vidi_igraca():
	vidi_igraca_ormar = true
	
func protivnik_proganja_igraca(proganja_igraca : bool) -> void:
	if igrac == null:
		return
	igrac.zauzet = proganja_igraca
			
func skriven_ui_moze_kretati(skriven_ui : bool):
	if igrac == null:
		return
	if skriven_ui != igrac.moze_kretati:
		igrac.moze_kretati = skriven_ui 

func promjena_boje_materijala(delta : float) -> void:
	if povecanje:
		ucestalost = ucestalost + delta * 0.7
	else:
		ucestalost = ucestalost - delta * 0.7
	if ucestalost >= 1.0:
		povecanje = false
	elif ucestalost <= 0:
		povecanje = true
	
	ucestalost = clamp(ucestalost, 0.0, 1.0)
	pod_materijal.albedo_color = pocetna_boja.lerp(iduca_boja, ucestalost)
