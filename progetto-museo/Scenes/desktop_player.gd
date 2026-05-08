extends CharacterBody3D

@export var walk_speed := 4.0
@export var sprint_speed := 7.0
@export var jump_velocity := 5.0
@export var mouse_sens := 0.002
@export var gravity := 9.8
@export var normal_fov := 75.0
@export var zoom_fov := 30.0
@export var zoom_speed := 10.0

var sta_scrivendo = false
var yaw := 0.0
var pitch := 0.0

@onready var cam: Camera3D = $Camera3D

func _ready():
	call_deferred("_capture_mouse")

func _capture_mouse():
	get_viewport().grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# MUOVI LA TELECAMERA SOLO SE IL MOUSE È CATTURATO
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * mouse_sens
		pitch -= event.relative.y * mouse_sens
		pitch = clamp(pitch, -1.2, 1.2)
		rotation.y = yaw
		cam.rotation.x = pitch

	# TASTO ESC (Attiva/Disattiva il mouse liberamente)
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Gravità applicata sempre
	if not is_on_floor():
		velocity.y -= gravity * delta

	# CONTROLLO MOVIMENTO
	if sta_scrivendo:
		# Se stiamo scrivendo, inchioda il giocatore a terra e impedisci di camminare/saltare
		velocity.x = 0
		velocity.z = 0
	else:
		# Salto (solo se non stiamo scrivendo e siamo a terra)
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
			
		# Direzione movimento
		var input_dir := Vector3.ZERO
		if Input.is_action_pressed("move_forward"):
			input_dir.z -= 1
		if Input.is_action_pressed("move_back"):
			input_dir.z += 1
		if Input.is_action_pressed("move_left"):
			input_dir.x -= 1
		if Input.is_action_pressed("move_right"):
			input_dir.x += 1

		input_dir = input_dir.normalized()
		var direction := (global_transform.basis * input_dir)
		direction.y = 0

		# Sprint
		var current_speed := walk_speed
		if Input.is_action_pressed("sprint"):
			current_speed = sprint_speed

		# Applica la velocità
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed

	# Muovi il corpo in base alla velocità calcolata
	move_and_slide()

func _process(delta):
	var target_fov = normal_fov
	
	if Input.is_action_pressed("zoom"):
		target_fov = zoom_fov
	cam.fov = lerp(cam.fov, target_fov, zoom_speed * delta)
	
