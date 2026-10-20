extends Interaktivni_objekt
class_name Okidac

@export var ukljuci_objekt : Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

const OKIDAC = preload("uid://bxgccdodjhbbv")
const metoda : String = "iskljuci_ukljuci"
const ukljuci_animacija : String = "ukljuci"
const iskljuci_animacija : String = "iskljuci"

var on_off : bool = false

func use() -> void:
	if animation_player.is_playing():
		return
	odigraj_audio(OKIDAC)
	promijeni_animaciju()
	if ukljuci_objekt != null and ukljuci_objekt.has_method(metoda):
		ukljuci_objekt.iskljuci_ukljuci()

func promijeni_animaciju() -> void:
	if on_off:
		animation_player.play(ukljuci_animacija)
	else:
		animation_player.play(iskljuci_animacija)
	on_off = !on_off
	
func odigraj_audio(audio : AudioStream) -> void:
	if audio_stream_player_3d.stream != audio:
		audio_stream_player_3d.stream = audio
	audio_stream_player_3d.play()
