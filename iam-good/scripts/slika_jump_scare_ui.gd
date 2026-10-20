extends Control

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var texture_rect: TextureRect = $TextureRect
@onready var timer: Timer = $Timer
var jump_scare_slika : Texture

const JUMP_SCARE = preload("uid://csh728eqbmdcu")

func _ready() -> void:
	texture_rect.visible = false
	
func prikazi_sliku(slika : Texture) -> void:
	if slika == null:
		return
	texture_rect.texture = slika
	texture_rect.visible = true

func makni_sliku() -> void:
	texture_rect.visible = false
	texture_rect.texture = null

func jump_scare(slika : Texture) -> void:
	jump_scare_slika = slika
	
func _on_texture_rect_hidden() -> void:
	if jump_scare_slika != null:
		timer.start()

func _on_timer_timeout() -> void:
	if jump_scare_slika == null:
		return
	UpraviteljSignala.jump_scare.emit()
	texture_rect.texture = jump_scare_slika
	texture_rect.visible = true
	odigraj_audio(JUMP_SCARE)
	await get_tree().create_timer(1.00).timeout
	jump_scare_slika = null
	makni_sliku()

func slika_vidljiv() -> bool:
	return texture_rect.visible
	
func odigraj_audio(audio : AudioStream) -> void:
	if audio_stream_player.stream != audio:
		audio_stream_player.stream = audio
	audio_stream_player.play()
