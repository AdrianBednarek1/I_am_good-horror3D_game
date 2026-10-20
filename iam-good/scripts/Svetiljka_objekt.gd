extends Item_objekt

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
const POKUPI_ITEM = preload("uid://doeqi52vmo1ht")

func _init() -> void:
	podaci_itema = Svetiljka_resurs.new()

func pokupi():
	odigraj_audio(POKUPI_ITEM)
	postavi_nevidljivo()
	await audio_stream_player_3d.finished
	super()
	
func odigraj_audio(audio : AudioStream) -> void:
	if audio_stream_player_3d.stream != audio:
		audio_stream_player_3d.stream = audio
	audio_stream_player_3d.play()
