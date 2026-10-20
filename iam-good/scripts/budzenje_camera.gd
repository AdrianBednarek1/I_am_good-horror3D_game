extends Camera3D
signal pocetna_scena_zavrsena

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const animacija_budzenje : String  = "budzenje"

func odigraj_animaciju():
	animation_player.play("budzenje")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pocetna_scena_zavrsena.emit()
	queue_free()
