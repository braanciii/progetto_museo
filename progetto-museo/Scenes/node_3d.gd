extends Node3D

# === PATH NODI ===============================================================

@export_node_path("Node3D")
var desktop_player_path: NodePath = "Player/DesktopPlayer"

@export_node_path("Node3D")
var xr_origin_path: NodePath = "Player/XROrigin3D"


# === REFERENCES ==============================================================

@onready var desktop_player: Node3D = get_node(desktop_player_path)
@onready var xr_origin: Node3D = get_node(xr_origin_path)

@onready var desktop_camera: Camera3D = $Player/DesktopPlayer/Camera3D
@onready var xr_camera: XRCamera3D = $Player/XROrigin3D/XRCamera3D

# Desktop ray
@onready var desktop_ray: RayCast3D = $Player/DesktopPlayer/Camera3D/RayCast3D

# XR ray (NELLA MANO, NON NELLA CAMERA)
@onready var xr_ray: RayCast3D = $Player/XROrigin3D/RightHand/RayCast3D


# === READY ===================================================================

func _ready() -> void:

	# Nasconde il mouse desktop
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	# Setup raycast
	desktop_ray.enabled = true
	desktop_ray.target_position = Vector3(0, 0, -100)

	xr_ray.enabled = true
	xr_ray.target_position = Vector3(0, 0, -20)

	# Inizializza OpenXR
	var xr_enabled := _initialize_openxr()

	# Attiva modalità corretta
	_set_vr_enabled(xr_enabled)


# === OPENXR ==================================================================

func _initialize_openxr() -> bool:

	var xr_interface := XRServer.find_interface("OpenXR")

	if xr_interface == null:
		print("OpenXR non trovato")
		return false

	if not xr_interface.is_initialized():
		var success := xr_interface.initialize()

		if not success:
			print("Impossibile inizializzare OpenXR")
			return false

	print("OpenXR inizializzato")

	return xr_interface.is_initialized()


# === VR ENABLE ===============================================================

func _set_vr_enabled(enable: bool) -> void:

	# Viewport XR
	get_viewport().use_xr = enable

	# Camera attiva
	desktop_camera.current = not enable
	xr_camera.current = enable

	# Visibilità
	desktop_player.visible = not enable
	xr_origin.visible = enable

	# Processing
	desktop_player.process_mode = (
		Node.PROCESS_MODE_INHERIT
		if not enable
		else Node.PROCESS_MODE_DISABLED
	)

	xr_origin.process_mode = (
		Node.PROCESS_MODE_INHERIT
		if enable
		else Node.PROCESS_MODE_DISABLED
	)

	print("VR attiva:", enable)


# === ACTIVE RAY ==============================================================

func get_active_ray() -> RayCast3D:

	if get_viewport().use_xr:
		return xr_ray

	return desktop_ray


# === PROCESS =================================================================

func _process(_delta: float) -> void:

	var ray := get_active_ray()

	if ray == null:
		return

	# POSIZIONE ORIGINE RAGGIO
	#var from = ray.global_transform.origin

	# DIREZIONE RAGGIO
	#var to = ray.to_global(ray.target_position)

	#print("RAY FROM: ", from)
	#print("RAY TO: ", to)

	# COLLISIONE
	if ray.is_colliding():

		var collision_point = ray.get_collision_point()
		var collision_normal = ray.get_collision_normal()
		var obj = ray.get_collider()

		#print("=== COLLISIONE ===")
		#print("Oggetto: ", obj.name)
		#print("Posizione collisione: ", collision_point)
		#print("Normale: ", collision_normal)

		if Input.is_action_just_pressed("click"):

			print("CLICK SU:", obj.name)

			if obj.has_method("on_clicked"):
				obj.on_clicked()


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
