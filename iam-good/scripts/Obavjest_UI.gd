extends Control

@onready var items_collected_text := $Items_collected
@onready var interact_text : RichTextLabel = $Interact
@onready var upozorenje: RichTextLabel = $Upozorenje
@onready var timer: Timer = $Timer
@onready var vrata_otkljucana : RichTextLabel = $Vrata_otkljucana
var player_raycast : RayCast3D

var uk_bodovi : int
var br_bodova : int = 0

func _ready() -> void:
	prikazi_interakciju(false)

func inicijalizacija(bodovi : Node3D, _raycast : RayCast3D):
	uk_bodovi = bodovi.get_child_count()
	items_collected_text.text =  str(br_bodova)+"/" + str(uk_bodovi)
	player_raycast = _raycast
	
func prikazi_vrata_otkljucana() -> void:
	vrata_otkljucana .visible = true
	timer.start(1)
	
func prikazi_interakciju(canInteract : bool)->void: 
	if interact_text.visible != canInteract:
		interact_text.visible = canInteract
	
func dodaj_bod()->void:
	br_bodova = br_bodova + 1
	items_collected_text.text =  str(br_bodova)+ "/" + str(uk_bodovi)

func prikazi_upozorenje(prikazi_tekst : bool) -> void:
	if upozorenje.visible != prikazi_tekst:
		upozorenje.visible = prikazi_tekst

func _on_timer_timeout() -> void:
	vrata_otkljucana.visible = false
