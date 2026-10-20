extends RayCast3D
var prosla_kolizija : bool

func _physics_process(delta: float) -> void:
	var objekt = self.get_collider()
	
	if objekt == null:
		if prosla_kolizija or prosla_kolizija == null:
			UpraviteljSignala.pickable.emit(false)
			prosla_kolizija = false
		return
		
	var objekt_interaktivan = UpraviteljKolizija.provjeri_layer(objekt, UpraviteljKolizija.LAYER.INTERAKCIJA)
	
	if objekt_interaktivan != prosla_kolizija:
		UpraviteljSignala.pickable.emit(objekt_interaktivan)
	prosla_kolizija = objekt_interaktivan
