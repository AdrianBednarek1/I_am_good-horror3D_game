extends Node3D
class_name Ormar

const otvori_animacija : String = "otvori"
const zatvori_animacija : String = "zatvori"
const game_over_animacija : String = "game_over"
const OTVARANJE_ORMARA = preload("uid://g7xwlcw4gk6n")

@onready var timer: Timer = $Timer
@onready var area_3d: Area3D = $Area3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var desna_vrata_ormar: Vrata_ormara = $vrata/desna_vrata_ormar
@onready var lijeva_vrata_ormar: Vrata_ormara = $vrata/lijeva_vrata_ormar
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

var ormar_se_otvara : bool = false

func _ready() -> void:
	UpraviteljSignala.connect("otvori_zatvori_vrata", otvori_zatvori_vrata)

func otvori_zatvori_vrata(vrata_ormar : Vrata):
	if !vrata_pripadaju_ormaru(vrata_ormar) or animation_player.is_playing():
		return
	if ormar_se_otvara:
		return
	otvori_ormar() 

func otvori_ormar() -> void:
	ormar_se_otvara = true
	odigraj_audio(OTVARANJE_ORMARA)
	animation_player.play(otvori_animacija)
	timer.start()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not CharacterBody3D or body == null:
		return
	UpraviteljSignala.ormar_usao_izasao.emit(self, true)
	
func _on_area_3d_body_exited(body: Node3D) -> void:
	UpraviteljSignala.ormar_usao_izasao.emit(self, false)
	
func vrata_pripadaju_ormaru(vrata_ormar : Vrata) -> bool:
	return vrata_ormar == desna_vrata_ormar or vrata_ormar == lijeva_vrata_ormar 

func _on_timer_timeout() -> void:
	animation_player.play(zatvori_animacija)
	ormar_se_otvara = false

	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == zatvori_animacija or anim_name == game_over_animacija:
		UpraviteljSignala.animacija_zavrsila.emit(self)
		
func otvori_polagano_ormar() -> void:
	animation_player.play("game_over")

	
func odigraj_audio(audio : AudioStream) -> void:
	if audio_stream_player_3d.stream != audio:
		audio_stream_player_3d.stream = audio
	audio_stream_player_3d.play()
