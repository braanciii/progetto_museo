extends Node3D

# Percorsi ai nodi — adattali se i nomi nella tua scena sono diversi
@export_node_path("Node3D") var desktop_player_path : NodePath = "DesktopPlayer"
@export_node_path("Node3D") var xr_origin_path : NodePath = "XROrigin3D"

@onready var desktop_player: Node = get_node_or_null(desktop_player_path)
@onready var xr_origin: Node = get_node_or_null(xr_origin_path)

@onready var desktop_ray = $DesktopPlayer/Camera3D/RayCast3D
@onready var xr_ray = $XROrigin3D/XRCamera3D/RayCast3D

func _ready():
	# tenta trovare l'interfaccia OpenXR
	var xr_interface := XRServer.find_interface("OpenXR")

	# prova a inizializzare solo se l'interfaccia esiste e non è inizializzata
	if xr_interface and not xr_interface.is_initialized():
		var ok := xr_interface.initialize()

	# decide se attivare XR (solo se interfaccia inizializzata)
	var xr_available := xr_interface and xr_interface.is_initialized()

	# imposta il viewport a XR se disponibile; altrimenti resta in desktop
	get_viewport().use_xr = xr_available

	_enable_vr(xr_available)


func _enable_vr(enable: bool) -> void:
	# sicurezza: controlli sui nodi
	if desktop_player:
		desktop_player.visible = not enable
		desktop_player.set_process(not enable)
		desktop_player.set_physics_process(not enable)
	if xr_origin:
		xr_origin.visible = enable
		xr_origin.set_process(enable)
		xr_origin.set_physics_process(enable)

	# per sicurezza, se entri in VR assicurati che viewport usi XR
	if enable:
		get_viewport().use_xr = true


func _on_button_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("Bottone 3D cliccato!")
		
func get_active_ray():
	if get_viewport().use_xr:
		return xr_ray
	else:
		return desktop_ray

func _process(delta):
	var ray = get_active_ray()
	
	print(get_active_ray())

	if ray and ray.is_colliding():
		var obj = ray.get_collider()

		if Input.is_action_just_pressed("click"):
			print("Colpito:", obj.name)

			if obj.has_method("on_clicked"):
				obj.on_clicked()
