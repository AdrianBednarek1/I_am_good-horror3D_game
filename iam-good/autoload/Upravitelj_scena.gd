extends Node

const menu : String = "res://scenes/glavne_scene/Menu.tscn"
const level1 : String = "res://scenes/glavne_scene/level1.tscn"
const test : String = "res://scenes/glavne_scene/level_test.tscn"
const pobjeda : String = "res://scenes/glavne_scene/Pobjeda.tscn"
const game_over : String = "res://scenes/glavne_scene/Game_over.tscn"
const ormar_game_over : String = "res://scenes/glavne_scene/ormar_game_over.tscn"

func promijeni_scenu(scena : String) -> void:
	get_tree().change_scene_to_file.call_deferred(scena)
	
func quit():
	get_tree().quit()
