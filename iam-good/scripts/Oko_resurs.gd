extends Item_resurs
class_name Oko_resurs

@export var trajanje : float = 5.00

func use(player : CharacterBody3D)->void:
	UpraviteljSignala.oko_pritisnuto.emit(self)
	
func aktiviraj_oko(igrac : CharacterBody3D, protivnik : CharacterBody3D) -> void:
	igrac.zauzet = true
	igrac.camera.clear_current()
	protivnik.camera.make_current()
	await igrac.get_tree().create_timer(trajanje).timeout
	if igrac == null:
		return
	igrac.camera.make_current()
	protivnik.camera.clear_current()
	igrac.zauzet = false
	
