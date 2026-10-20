extends CharacterBody3D
class_name Igrac

const OKIDAC = preload("uid://bxgccdodjhbbv")
const KLJUC = preload("uid://bk4kd724h4u8h")

@export_range(0.00,180.00) var rotacija_stupnjevi : float = 75
@export_range(0.0001, 0.01) var osjetljivost_misa : float = 0.003

var dopustena_rotacija : float = deg_to_rad(rotacija_stupnjevi)
var svetiljka : bool = false
var hodanje : float = 5.0
var trcanje : float = 10.0
var brzina : float = 5.0
const skakanje : float = 4.5

var trci : bool = false
var dupli_skok : bool = false
var skriven_ui : bool = true
var zauzet : bool = false
var moze_kretati : bool = true
var objekt_interaktivan : bool = false

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var raycast: RayCast3D = $tijelo/RayCast3D
@onready var direkcija_misa := $glava
@onready var flashlight := $glava/flashlight
@onready var inventar: Inventar = $inventar
@onready var camera: Camera3D = $glava/SpringArm3D/Camera3D
@onready var tijelo: Node3D = $tijelo

const PADANJE_ANIM : String = "igrac/padanje"
const TRCANJE_ANIM : String = "igrac/trcanje"
const HODANJE_ANIM : String = "igrac/hodanje"
const IDLE_ANIM : String = "igrac/idle"

func _ready() -> void:
	UpraviteljSignala.connect("pickable", objekt_je_interaktivan)
	UpraviteljSignala.connect("item_pritisnut", item_pritisnut)
	UpraviteljSignala.connect("sav_ui_skriven", sav_ui_skriven)
	
func _process(delta: float) -> void:
	if not is_on_floor():
		pokreni_animaciju(PADANJE_ANIM)
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	kretanje()
	move_and_slide()
	
	if Input.is_action_just_pressed("flashlight") and svetiljka:
		odigraj_audio(OKIDAC)
		upali_ugasi_svjetiljku(!flashlight.visible)
		
	if Input.is_action_just_pressed("inventory") and !zauzet:
		UpraviteljSignala.inventory.emit()
		
	if Input.is_action_just_pressed("esc") and !zauzet:
		UpraviteljSignala.esc_pritisnut.emit()

	if objekt_interaktivan and Input.is_action_just_pressed("interact") and skriven_ui:
		player_ima_interakciju()
			
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and skriven_ui:
		dopustena_rotacija = deg_to_rad(rotacija_stupnjevi)
		direkcija_misa.rotate_x(-event.relative.y * osjetljivost_misa)
		direkcija_misa.rotation.x = clampf(direkcija_misa.rotation.x, -dopustena_rotacija,dopustena_rotacija)
		rotate_y(-event.relative.x * osjetljivost_misa)

func sav_ui_skriven(_skriven_ui : bool):
	skriven_ui = _skriven_ui

func objekt_je_interaktivan(canInteract : bool):
	objekt_interaktivan = canInteract

func player_ima_interakciju() -> void:
		var objekt = raycast.get_collider()
		if objekt is Item_objekt:
			objekt.pokupi()
			inventar.dodaj(objekt.podaci_itema as Item_resurs)
		if objekt is Interaktivni_objekt:
			objekt.use()

func upali_ugasi_svjetiljku(ukljucen : bool) -> void:
	flashlight.visible = ukljucen

func item_pritisnut(item_id : String):	
	var stvar = inventar.dohvati(item_id)
	if stvar != null:
		stvar.use(self)
		if stvar is Svetiljka_resurs:
			odigraj_audio(KLJUC)
	
func makni_sa_inventara(item_id : String):
	var item = inventar.dohvati(item_id)
	if item_id != null:
		inventar.obrisi(item_id)
		UpraviteljSignala.maknut_item.emit(item_id)
	
func dohvati_inventar()->Dictionary[String, Item_resurs]:
	return inventar.dohvati_sve()

func odigraj_audio(audio : AudioStream) -> void:
	if audio_stream_player_3d.stream != audio:
		audio_stream_player_3d.stream = audio
	audio_stream_player_3d.play()

func kretanje():
	if !moze_kretati:
		ostaje_na_mjestu()
		return
	
	if Input.is_action_pressed("run"):
		if brzina != trcanje:
			trci = true
			brzina = trcanje
	elif brzina != hodanje:
		trci = false
		brzina = hodanje

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = skakanje
	
	if Input.is_action_just_pressed("jump") and not is_on_floor() and dupli_skok:
		dupli_skok = false
		velocity.y = skakanje
	
	if is_on_floor():
		dupli_skok = true
		
	var input : Vector2 = Input.get_vector("left", "right", "forward", "back")
	var smjer : Vector3 = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	
	if smjer != Vector3.ZERO:
		if trci and is_on_floor() :
			pokreni_animaciju(TRCANJE_ANIM)
		elif is_on_floor(): 
			pokreni_animaciju(HODANJE_ANIM)
			
		velocity.x = smjer.x * brzina
		velocity.z = smjer.z * brzina
		tijelo.look_at(smjer + position)
	else:
		ostaje_na_mjestu()

func ostaje_na_mjestu() -> void:
	pokreni_animaciju(IDLE_ANIM)
	velocity.x = 0
	velocity.z = 0
	
func vrati_kameru() -> Camera3D:
	return camera

func vrati_collision_shape() -> CollisionShape3D:
	return collision_shape_3d

func dohvati_raycast() -> RayCast3D:
	return raycast

func dohvati_koliziju() -> Object:
	return raycast.get_collider()

func pokreni_animaciju(anim : String) -> void:
	if animation_player.current_animation != anim:
		animation_player.play(anim)
