extends Node3D

@onready var animation_player: AnimationPlayer = $Brzo_trcanje/AnimationPlayer
@onready var timer: Timer = $Brzo_trcanje/Timer
@onready var brzo_trcanje: Node3D = $Brzo_trcanje
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $Brzo_trcanje/AudioStreamPlayer3D

const ZASTRASIVANJE = preload("uid://botwtwgwie5hs")
const brzo_trcanje_anim : String = "mixamo_com"

func _ready() -> void:
	brzo_trcanje.visible = false
	audio_stream_player_3d.stream =ZASTRASIVANJE
	
func pokreni_animaciju() -> void:
	brzo_trcanje.visible = true
	animation_player.play(brzo_trcanje_anim)
	audio_stream_player_3d.play()
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()
