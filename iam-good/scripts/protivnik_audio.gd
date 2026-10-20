extends AudioStreamPlayer3D

var igrac_lokacija : CharacterBody3D
var protivnik_lokacija : CharacterBody3D
var udaljenost_igraca : float = 0
const default_unite_size : float = 8

func inicijalizacija(_igrac : CharacterBody3D, _protivnik : CharacterBody3D) -> void:
	igrac_lokacija = _igrac
	protivnik_lokacija = _protivnik
	
func _physics_process(delta: float) -> void:
	if igrac_lokacija == null:
		return
		
	udaljenost_igraca = igrac_lokacija.global_position.y - protivnik_lokacija.global_position.y
	udaljenost_igraca = pow(udaljenost_igraca,2)
	if udaljenost_igraca> default_unite_size:
		udaljenost_igraca = default_unite_size
	unit_size = default_unite_size - udaljenost_igraca
	
func _on_finished() -> void:
	play()
