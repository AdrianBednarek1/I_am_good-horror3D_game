extends Node3D

@export var upravitelj: Node
@export var upravitelj_ui: Control 
@export var upravitelj_glazbe: Node
@export var player: CharacterBody3D
@export var vrata_cilj: StaticBody3D
@export var protivnik: CharacterBody3D 

@onready var mapa: Node3D = $Mapa
@onready var papiri: Node3D = $interaktivne_stvari/PAPIRI
@onready var pocetna_scena: Camera3D = $pocetna_scena

@onready var pin_ui: Control = $CanvasLayer/pin_ui
@onready var inventar_ui: Control = $CanvasLayer/inventar_ui
@onready var obavjest_ui: Control = $CanvasLayer/obavjest_ui
@onready var item_pregled_ui: Control = $CanvasLayer/item_pregled_ui
@onready var slika_jump_scare_ui: Control = $CanvasLayer/slika_jump_scare_ui

func _ready() -> void:
	var inventar = player.dohvati_inventar()
	var sobe : Node3D = mapa.dohvati_sobe()
	
	inventar_ui.inicijalizacija(inventar)
	protivnik.inicijalizacija(player, sobe)
	upravitelj_glazbe.inicijalizacija(protivnik)
	obavjest_ui.inicijalizacija(papiri, player.dohvati_raycast())
	upravitelj.inicijalizacija(player, protivnik, vrata_cilj, papiri, pocetna_scena)
	upravitelj_ui.inicijalizacija(item_pregled_ui, inventar_ui, obavjest_ui, pin_ui, slika_jump_scare_ui)
	
	UpraviteljSignala.connect("kraj_igre", kraj_igre)
	UpraviteljSignala.connect("igrac_pobjedio", igrac_pobjedio)

func kraj_igre(scena : String) -> void:
	Upravitelj_scena.promijeni_scenu(scena)
	
func igrac_pobjedio() -> void:
	kraj_igre(Upravitelj_scena.pobjeda)
