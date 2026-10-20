extends Area3D
class_name Item_objekt

@export var podaci_itema : Item_resurs 

func pokupi():
	UpraviteljSignala.item_collected.emit(podaci_itema)
	queue_free()
	
func postavi_nevidljivo() -> void:
	var djeca = get_children()
	for djete in djeca:
		if djete is not AudioStreamPlayer3D:
			djete.queue_free()
