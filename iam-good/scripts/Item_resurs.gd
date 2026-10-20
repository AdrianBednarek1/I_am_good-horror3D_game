extends Resource
class_name Item_resurs

var Id : String
@export var Name : String
@export var Item_Image : Texture2D
@export var unique : bool

func use(player : CharacterBody3D) ->void:
	pass

func _init() -> void:
	if Id == "" or Id == null:
		Id = GenerirajId.Novi_Id()
