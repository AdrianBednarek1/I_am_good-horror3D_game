extends Control

@onready var panel_container: PanelContainer = $PanelContainer
@onready var grid := $PanelContainer/MarginContainer/GridContainer
@onready var naziv_itema: RichTextLabel = $naziv_itema

var okvir : PackedScene = load("res://scenes/UI/button.tscn")
var inventar : Dictionary[String, Item_resurs] 

func _ready() -> void:
	panel_container.visible = false
	
func inicijalizacija(_inventar : Dictionary[String, Item_resurs]) -> void:
	inventar = _inventar

func refresh_inventar() -> void:
	var djeca = grid.get_children()
	for djete in djeca:
		djete.obrisi()
	for stvar in inventar.values():
		dodaj_item(stvar)

func otvori_zatvori() -> void:
	if inventar_otvoren():
		sakrij_inventar()
		return
	prikazi_inventar()
	
func kreiraj_okvir() -> item_okvir:
	var okvir_djete = okvir.instantiate() as item_okvir
	okvir_djete.mouse_entered.connect(prikazi_naziv.bind(okvir_djete))
	okvir_djete.mouse_exited.connect(sakrij_naziv)
	grid.add_child(okvir_djete)
	return okvir_djete


func makni_item(id : String):
	var djeca = grid.get_children()
	var indeks = djeca.find_custom(func(item): return item.pronadzi(id))
	if indeks > -1:
		djeca[indeks].obrisi_item(id)

func dodaj_item(item : Item_resurs) -> void:
	if !item.unique:
		var djeca = grid.get_children()
		var indeks = djeca.find_custom(func(_item): return _item.tip == item.get_script())
		if indeks >= 0:
			djeca[indeks].popuni_okvir(item)
			return
	var _okvir = kreiraj_okvir() 
	_okvir.popuni_okvir(item)
	
func prikazi_naziv(okvir : Button) -> void:
	naziv_itema.text = okvir.dohvati_naziv()
	
func sakrij_naziv() -> void:
	naziv_itema.text = ""
	
func prikazi_inventar() -> void: 
	if inventar_otvoren():
		return
	panel_container.visible = true
		
func sakrij_inventar():
	if !inventar_otvoren():
		return
	panel_container.visible = false

func inventar_otvoren() -> bool:
	return panel_container.visible
