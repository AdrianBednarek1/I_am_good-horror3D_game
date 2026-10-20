extends CharacterBody3D

@export var brzina : float = 4.5
@export_range(0.1,1.0) var velicina_playera : float = 0.5

@onready var timer: Timer = $Timer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var raycast: RayCast3D = $RayCast3D
@onready var camera: Camera3D = $Camera3D
@onready var glava: Node3D = $glava
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

const HORROR_1 = preload("uid://baal3ra5pkb8g")
const idle : String = "protivnik/Idle"


var lokacije_patrole : Array[Vector3] = []
var igrac : CharacterBody3D
var destinacija : Vector3

var destinacija_prazna : bool = true
var vidi_igraca : bool = false
var proganja_igraca : bool = false
var treba_javiti : bool = false
var igrac_ulovljen : bool = false
var moze_zumirati : bool = false

func _ready() -> void:
	audio_stream_player_3d.stream = HORROR_1
	audio_stream_player_3d.play()
	animation_player.play(idle)
	
func inicijalizacija(_igrac : CharacterBody3D, _lokacije_patrole : Node3D):
	igrac = _igrac
	audio_stream_player_3d.inicijalizacija(igrac, self)
	var lokacije_djeca = _lokacije_patrole.get_children()
	for djete in lokacije_djeca:
		lokacije_patrole.append(djete.global_position)

func rotiraj_kameru() -> void:
	camera.look_at(glava.global_position)

func zumiraj() -> void:
	camera.fov = lerp(camera.fov, 20.00, 0.15)
	
func _process(delta:  float) -> void:
	if moze_zumirati:
		zumiraj()
		
	if igrac_ulovljen:
		return
	
	azuriraj_raycast_igraca()
	
	var kolizija = raycast.get_collider()
	
	if kolizija is Igrac:
		var dovoljno_blizu : bool = global_position.distance_to(igrac.global_position) <= 3
		if dovoljno_blizu:
			igrac_ulovljen = true
			UpraviteljSignala.ulovio_igraca.emit()
			return
		postavi_vidi_igraca(true)
		postavi_proganja_igraca(true)
		timer.start()
	else:
		postavi_vidi_igraca(false)
		
	if kolizija is Vrata_ormara:
		var udaljenost_igraca = raycast.get_collision_point()
		var dovoljno_blizu : bool = global_position.distance_to(udaljenost_igraca) <= 4
		if dovoljno_blizu and proganja_igraca:
			igrac_ulovljen = true
			UpraviteljSignala.ulovio_igraca.emit()
			return
		
	var blizu_odredista : bool = global_position.distance_to(destinacija) <= 2
	var ne_pripada_patroli : bool = !lokacije_patrole.has(destinacija)
	
	if proganja_igraca:
		postavi_odrediste(igrac.global_position)
	elif ne_pripada_patroli or blizu_odredista:
		postavi_odrediste(lokacije_patrole.pick_random())
		
	kretanje_rotacija_protivnika(delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func kretanje_rotacija_protivnika(delta : float) -> void:
	var smjer =  global_position.direction_to(navigation_agent_3d.get_next_path_position()).normalized()
	velocity = smjer * brzina
	
	var okrenut_prema = global_position + Vector3(smjer.x, 0, smjer.z)
	if not global_position.is_equal_approx(okrenut_prema):
		var smjer_gledanja = global_transform.looking_at(okrenut_prema)
		global_basis = global_basis.slerp(smjer_gledanja.basis, delta * 4)

func azuriraj_raycast_igraca() -> void:
	raycast.target_position = raycast.to_local(igrac.global_position + Vector3.UP * velicina_playera)
	raycast.force_raycast_update()

func postavi_odrediste(_odrediste : Vector3) -> void:
	navigation_agent_3d.target_position = _odrediste
	destinacija = navigation_agent_3d.target_position

func postavi_vidi_igraca(_vidi_igraca : bool) -> void:
	if _vidi_igraca != vidi_igraca:
		vidi_igraca = _vidi_igraca
	if vidi_igraca and treba_javiti:
		UpraviteljSignala.protivnik_vidi_igraca.emit()
	
func postavi_proganja_igraca(_proganja_igraca : bool) -> void:
	if _proganja_igraca == proganja_igraca:
		return
	proganja_igraca = _proganja_igraca
	UpraviteljSignala.protivnik_proganja.emit(proganja_igraca)

func dohvati_audio() -> AudioStreamPlayer3D :
	return audio_stream_player_3d

func dohvati_navigation_agent() -> NavigationAgent3D:
	return navigation_agent_3d
		
func _on_timer_timeout() -> void:
	postavi_proganja_igraca(false)

func vrati_kameru() -> Camera3D:
	return camera
