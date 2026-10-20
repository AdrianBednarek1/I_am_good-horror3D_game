extends Area3D
class_name Teleport

@export var drugi_teleport : Teleport
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and drugi_teleport != null:
		var box_shape = collision_shape_3d.shape as BoxShape3D
		var sirina = box_shape.size.x * drugi_teleport.scale.x
		body.global_transform = drugi_teleport.global_transform
		body.global_position += - body.global_basis.z * sirina
			
