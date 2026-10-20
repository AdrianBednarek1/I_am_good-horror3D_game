extends HSlider

@export var audio_bus : String
var id_audio_bus : int = 0

func _ready() -> void:
	id_audio_bus = AudioServer.get_bus_index(audio_bus)
	value = AudioServer.get_bus_volume_linear(id_audio_bus)
	value_changed.connect(_on_value_changed)
	
func _on_value_changed(value: float) -> void:
	if id_audio_bus >= 0 :
		AudioServer.set_bus_volume_db(id_audio_bus, linear_to_db(value))
	
