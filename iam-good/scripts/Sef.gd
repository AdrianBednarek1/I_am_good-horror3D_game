extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sef_vrata: Vrata_sefa = $Sef_vrata
@onready var kod: Node = $Kod
@export var pin : String

const OTKLJUCAVANJE = preload("uid://yoi5tbvy710h")
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	kod.postavi_pin(pin)
	UpraviteljSignala.connect("otvori_zatvori_vrata", otvori_vrata)

func otvori_vrata(_vrata : Vrata) -> void:
	if sef_vrata == _vrata:
		UpraviteljSignala.prikazi_pin.emit(self)

func upisi_pin(_pin : String) -> bool:
	var pin_ispravan : bool = kod.otkljucaj(_pin)
	if pin_ispravan:
		otvori_sef()
	return pin_ispravan

func otvori_sef() -> void:
	animation_player.play("otvori")
	odigraj_audio(OTKLJUCAVANJE)
	UpraviteljKolizija.postavi_layer(sef_vrata,UpraviteljKolizija.LAYER.INTERAKCIJA, false)
	UpraviteljKolizija.postavi_layer(sef_vrata,UpraviteljKolizija.LAYER.OPIPLJIVI_OBJEKTI, true)
	
func odigraj_audio(audio : AudioStream) -> void:
	if audio_stream_player_3d.stream != audio:
		audio_stream_player_3d.stream = audio
	audio_stream_player_3d.play()
	
