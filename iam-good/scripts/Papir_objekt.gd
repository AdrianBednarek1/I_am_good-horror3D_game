extends Item_objekt
class_name Papir_objekt

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var okvir: MeshInstance3D = $MeshInstance3D

const PAPIR = preload("uid://bloglj5o73t8")
var materijal : StandardMaterial3D = StandardMaterial3D.new()

func _init() -> void:
	podaci_itema = Papir_resurs.new()
	
func _ready() -> void:
	postavi_sliku()

func pokupi():
	odigraj_audio(PAPIR)
	postavi_nevidljivo()
	await audio_stream_player_3d.finished
	super()
	
func postavi_sliku() -> void:
	if podaci_itema.Item_Image != null:
		materijal.albedo_texture = podaci_itema.Item_Image
		okvir.material_override = materijal
		
func odigraj_audio(audio : AudioStream) -> void:
	if audio_stream_player_3d.stream != audio:
		audio_stream_player_3d.stream = audio
	audio_stream_player_3d.play()
	
	
