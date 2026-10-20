extends Item_resurs
class_name Svetiljka_resurs
	
func use(player : CharacterBody3D) ->void:
	player.svetiljka = !player.svetiljka
	if !player.svetiljka:
		player.upali_ugasi_svjetiljku(player.svetiljka)
