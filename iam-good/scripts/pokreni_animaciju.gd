extends Area3D

@export var animacija_objekta : Node3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	mesh_instance_3d.visible = false

func _on_body_entered(body: Node3D) -> void:
	if animacija_objekta == null:
		queue_free()
		return
	animacija_objekta.pokreni_animaciju()
	queue_free()
