extends Item_objekt
class_name Kljuc_objekt

const KLJUC = preload("uid://bk4kd724h4u8h")
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _init() -> void:
	podaci_itema = Kljuc_resurs.new() 

func pokupi():
	odigraj_audio(KLJUC)
	postavi_nevidljivo()
	await audio_stream_player_3d.finished
	super()

func odigraj_audio(audio : AudioStream) -> void:
	if audio_stream_player_3d.stream != audio:
		audio_stream_player_3d.stream = audio
	audio_stream_player_3d.play()
