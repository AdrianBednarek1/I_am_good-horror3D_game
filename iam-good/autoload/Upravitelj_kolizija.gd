extends Node

enum LAYER {
	POD = 1, 
	IGRAC = 2, 
	INTERAKCIJA = 3, 
	PROTIVNIK = 4, 
	OPIPLJIVI_OBJEKTI = 5, 
	ZID = 6
	}

func postavi_layer(objekt : CollisionObject3D, layer : LAYER, ukljucen : bool) -> void:
	objekt.set_collision_layer_value(layer, ukljucen)
	
func provjeri_layer(objekt : CollisionObject3D, layer : LAYER) -> bool:
	return objekt.get_collision_layer_value(layer)
