extends Interaktivni_objekt
class_name Slika

@export var iduca_slika: Texture
@export var trenutna_slika : Texture
@onready var platno: MeshInstance3D = $MeshInstance3D2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const animacija_rotiraj : String = "rotiraj"
var materijal : StandardMaterial3D = StandardMaterial3D.new()
var postoji_jumpscare : bool = false
var igrac_vidio : bool = false

func _ready() -> void:
	postoji_jumpscare = iduca_slika != null
	postavi_sliku()

func use() -> void:
	UpraviteljSignala.interakcija_slika.emit(self, postoji_jumpscare)
	igrac_vidio = true
	
func postavi_sliku() -> void:
	if trenutna_slika != null:
		materijal.albedo_texture = trenutna_slika
		platno.material_override = materijal
	
func promjena_slike() -> void:
	if postoji_jumpscare:
		trenutna_slika = iduca_slika
		materijal.albedo_texture = trenutna_slika
	postoji_jumpscare = false
	iduca_slika = null

func pokreni_animaciju() -> void:
	animation_player.play(animacija_rotiraj)
