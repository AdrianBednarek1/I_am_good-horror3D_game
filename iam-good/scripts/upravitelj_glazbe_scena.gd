extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@export var audio_stream : AudioStream

func _ready() -> void:
	if audio_stream != null:
		audio_stream_player.stream = audio_stream
		audio_stream_player.play()
