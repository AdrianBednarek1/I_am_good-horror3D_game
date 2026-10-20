extends Item_resurs
class_name  Trokut_resurs

@export var trajanje : float = 10.00
var materijal : StandardMaterial3D
var timer_poceo : bool = false
var putanja_protivnika: PackedVector3Array

func use(igrac : CharacterBody3D)->void:
	postavi_materijal()
	UpraviteljSignala.trokut_pritisnut.emit(self)
	
func postavi_materijal() -> void:
	materijal = StandardMaterial3D.new()
	materijal.no_depth_test = true
	materijal.cull_mode = BaseMaterial3D.CULL_DISABLED
	materijal.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	materijal.albedo_color = Color.RED

func napravi_putanju(trenutna_patrola: NavigationAgent3D) -> Node3D:
	var roditelj := Node3D.new()
	putanja_protivnika.clear()
	azuriraj_putanju(trenutna_patrola, roditelj)	
	return roditelj

func azuriraj_putanju(trenutna_patrola: NavigationAgent3D, roditelj: Node3D) -> void:
	var nova_putanja : PackedVector3Array = trenutna_patrola.get_current_navigation_path()
	if nova_putanja == putanja_protivnika:
		return
	putanja_protivnika = nova_putanja
	for djete in roditelj.get_children():
		djete.queue_free()
	if nova_putanja.size() < 2:
		return

	for i in range(nova_putanja.size() - 1):
		var pocetak : Vector3 = nova_putanja[i] + Vector3.UP * 0.5
		var kraj : Vector3 = nova_putanja[i + 1] + Vector3.UP * 0.5
		var linija := MeshInstance3D.new()
		var mesh := QuadMesh.new()
		var duzina : float = pocetak.distance_to(kraj)

		mesh.size = Vector2(0.1, duzina)
		linija.mesh = mesh
		linija.material_override = materijal
		roditelj.add_child(linija)
		linija.global_position = (pocetak + kraj) / 2
		var smjer_duzine : Vector3 = pocetak.direction_to(kraj)
		var x := Vector3.UP.cross(smjer_duzine)
		var z : Vector3 = x.cross(smjer_duzine)
		linija.basis = Basis(x,smjer_duzine,z)
		
	
func pokreni_timer(protivnik_patrola : NavigationAgent3D) -> void:
	await protivnik_patrola.get_tree().create_timer(trajanje).timeout
