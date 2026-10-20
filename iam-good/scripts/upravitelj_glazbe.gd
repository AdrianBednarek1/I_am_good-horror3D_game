extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const ULOVLJEN = preload("uid://d0412r5wi7oee")
const I_AM_GOOD_EXIT_OPENED = preload("uid://cgyf3lnb5dqpp")

var izlaz_otvoren : bool = false
var protivnik_zvuk : AudioStreamPlayer3D

func _ready() -> void:
	UpraviteljSignala.connect("protivnik_proganja", pokreni_glazbu_progona)
	UpraviteljSignala.connect("ulovio_igraca", ulovio_igraca)
	UpraviteljSignala.connect("izlaz_otvoren", pusti_zavrsnu_glazbu)

func inicijalizacija(_protivnik : CharacterBody3D) -> void:
	protivnik_zvuk = _protivnik.dohvati_audio()

func pokreni_glazbu_progona(pokreni_glazbu : bool) -> void:
	if izlaz_otvoren:
		return
	if pokreni_glazbu:
		ukljuci_autoplay(true)
		audio_stream_player.play()
		protivnik_zvuk.stop()
	else:
		protivnik_zvuk.play()
		audio_stream_player.stop()

func ulovio_igraca() -> void:
	audio_stream_player.stream = ULOVLJEN
	ukljuci_autoplay(false)
	audio_stream_player.play()
	protivnik_zvuk.stop()

func pusti_zavrsnu_glazbu() -> void:
	protivnik_zvuk.stop()
	izlaz_otvoren = true
	audio_stream_player.stream = I_AM_GOOD_EXIT_OPENED
	audio_stream_player.autoplay = true
	ukljuci_autoplay(true)
	audio_stream_player.play(51.00)

func ukljuci_autoplay(ukljuci : bool) -> void:
	if audio_stream_player.autoplay != ukljuci:
		audio_stream_player.autoplay = ukljuci
