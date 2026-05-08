extends Node3D

@export var desktop_player_path: NodePath = NodePath("DesktopPlayer")
@export var xr_origin_path: NodePath = NodePath("XROrigin3D")

# opzionale: se vuoi spegnere collisioni in modo sicuro
@export var desktop_collision_layer: int = 1
@export var xr_collision_layer: int = 1

@onready var desktop_player: Node = get_node_or_null(desktop_player_path)
@onready var xr_origin: Node = get_node_or_null(xr_origin_path)

var xr_interface: XRInterface

func _ready() -> void:
	# Prendi interfaccia OpenXR (se esiste)
	xr_interface = XRServer.find_interface("OpenXR")

	# Prova ad attivare XR: se fallisce, resta desktop
	var xr_ok := await _try_enable_xr()
	_set_mode(xr_ok)

func _unhandled_input(event: InputEvent) -> void:
	# Switch manuale (opzionale): F9
	if event.is_action_pressed("ui_focus_next"): # se vuoi usare F9 senza creare action, cambia sotto
		pass

	# Consigliato: crea un'azione "toggle_vr" e mappa F9 in Input Map
	if event.is_action_pressed("toggle_vr"):
		var want_vr := not get_viewport().use_xr
		if want_vr:
			await _try_enable_xr()
		else:
			_disable_xr()
			_set_mode(false)

func _try_enable_xr() -> bool:
	if not xr_interface:
		return false

	if not xr_interface.is_initialized():
		xr_interface.initialize()

	# Se non si inizializza davvero, niente XR
	if not xr_interface.is_initialized():
		return false

	# Prova ad entrare in XR
	get_viewport().use_xr = true

	# Se OpenXR non riesce a partire, Godot può tornare a normal mode.
	# Aspetta 1 frame e ricontrolla
	await get_tree().process_frame
	return get_viewport().use_xr

func _disable_xr() -> void:
	get_viewport().use_xr = false

func _set_mode(vr_enabled: bool) -> void:
	# Desktop ON / VR OFF
	if desktop_player:
		desktop_player.visible = not vr_enabled
		desktop_player.set_process(not vr_enabled)
		desktop_player.set_physics_process(not vr_enabled)
		_set_collision_enabled(desktop_player, desktop_collision_layer, not vr_enabled)

	# VR ON / Desktop OFF
	if xr_origin:
		xr_origin.visible = vr_enabled
		xr_origin.set_process(vr_enabled)
		xr_origin.set_physics_process(vr_enabled)
		_set_collision_enabled(xr_origin, xr_collision_layer, vr_enabled)

func _set_collision_enabled(node: Node, layer: int, enabled: bool) -> void:
	# Spegne/accende collisioni se il nodo (o un figlio) è un CollisionObject3D/CharacterBody3D
	if node is CollisionObject3D:
		node.set_collision_layer_value(layer, enabled)
		node.set_collision_mask_value(layer, enabled)

	# Prova anche sui figli (per XR rig spesso le collisioni stanno in un child)
	for child in node.get_children():
		if child is Node:
			_set_collision_enabled(child, layer, enabled)

# Aggiungi questa funzione alla fine dello script del Player
func _input(event):
	if event.is_action_pressed("ui_cancel"): # Di default corrisponde al tasto ESC
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # Libera il mouse
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Ricattura il mouse
