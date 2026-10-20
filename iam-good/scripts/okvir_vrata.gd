extends StaticBody3D
class_name Okvir_vrata

@export var otkljucano : bool = true
@export var kljuc : Kljuc_objekt

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var vrata: Vrata = $vrata
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

const OTKLJUCAVANJE = preload("uid://yoi5tbvy710h")
const OTVARANJE_VRATA = preload("uid://2d7mf2rd6s2k")
const otvori_animacija : String = "otvori"
const zatvori_animacija : String = "zatvori"
var animacija_traje : bool = false

func _ready() -> void:
	UpraviteljSignala.connect("otvori_zatvori_vrata", otvori_zatvori)
	UpraviteljSignala.connect("vrata_otkljucana", vrata_otkljucana)
	vrata.postavi_kljuc(dohvati_kljuc())

func otvori_zatvori(_vrata : Vrata) -> void:
	if !vrata_pripadaju_okviru(_vrata) or animation_player.is_playing():
		return
	if !otkljucano:
		UpraviteljSignala.otkljucavanje_vrata.emit(self)
		return
	if animacija_traje:
		return
	otvori_vrata() 
	timer.start()
	
func _on_timer_timeout() -> void:
	animation_player.play(zatvori_animacija)
	animacija_traje = false
	
func vrata_otkljucana(_vrata : Vrata) -> void:
	if vrata_pripadaju_okviru(_vrata):
		odigraj_audio(OTKLJUCAVANJE)
		otkljucaj_vrata()
		
func dohvati_kljuc() -> Kljuc_resurs:
	if kljuc == null:
		return null
	otkljucano = false
	return kljuc.podaci_itema as Kljuc_resurs
	
func vrata_pripadaju_okviru(_vrata : Vrata) -> bool:
	return vrata == _vrata

func otvori_vrata() -> void:
	animacija_traje = true
	odigraj_audio(OTVARANJE_VRATA)
	animation_player.play(otvori_animacija)
	
func otkljucaj_vrata() -> void:
	otkljucano = true
	
func zakljucaj_vrata() -> void:
	otkljucano = false
	
func odigraj_audio(audio : AudioStream) -> void:
	if audio_stream_player_3d.stream != audio:
		audio_stream_player_3d.stream = audio
	audio_stream_player_3d.play()
