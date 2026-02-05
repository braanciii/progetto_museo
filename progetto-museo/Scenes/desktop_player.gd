extends Node3D

# Assegna questi due nodi dall’Inspector
@export var desktop_player: Node3D
@export var xr_origin: Node3D

func _ready():
	# Debug: verifica subito se qualcosa è null
	print("desktop_player =", desktop_player)
	print("xr_origin =", xr_origin)

	# Cerca OpenXR
	var xr_interface := XRServer.find_interface("OpenXR")

	# Inizializza XR se possibile
	if xr_interface and not xr_interface.is_initialized():
		xr_interface.initialize()

	var xr_available := xr_interface and xr_interface.is_initialized()

	# Attiva o meno XR
	get_viewport().use_xr = xr_available
	_enable_vr(xr_available)


func _enable_vr(enable: bool) -> void:
	# Desktop player
	if is_instance_valid(desktop_player):
		desktop_player.visible = not enable
		desktop_player.set_process(not enable)
		desktop_player.set_physics_process(not enable)

	# XR Origin
	if is_instance_valid(xr_origin):
		xr_origin.visible = enable
		xr_origin.set_process(enable)
		xr_origin.set_physics_process(enable)

	if enable:
		get_viewport().use_xr = true


# ─────────────────────────────
# ESEMPIO SICURO DI ROTAZIONE
# (non andrà mai in crash)
# ─────────────────────────────
func rotate_desktop_player(yaw_delta: float) -> void:
	if not is_instance_valid(desktop_player):
		return

	desktop_player.rotation.y += yaw_delta


func rotate_xr_origin(yaw_delta: float) -> void:
	if not is_instance_valid(xr_origin):
		return

	xr_origin.rotation.y += yaw_delta
