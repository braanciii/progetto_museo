extends CharacterBody3D

@export var walk_speed := 4.0
@export var sprint_speed := 7.0
@export var fly_speed := 10.0       # Velocità di volo
@export var jump_velocity := 5.0
@export var mouse_sens := 0.002
@export var gravity := 9.8
@export var normal_fov := 75.0
@export var zoom_fov := 30.0
@export var zoom_speed := 10.0

var sta_scrivendo = false
var is_flying = false             # Stato del volo
var yaw := 0.0
var pitch := 0.0

@onready var ui_hint = $UIHint
@onready var cam: Camera3D = $Camera3D

func _ready():
	call_deferred("_capture_mouse")

func _capture_mouse():
	get_viewport().grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * mouse_sens
		pitch -= event.relative.y * mouse_sens
		pitch = clamp(pitch, -1.2, 1.2)
		rotation.y = yaw
		cam.rotation.x = pitch

	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	# TASTO PER ATTIVARE/DISATTIVARE IL VOLO (es. tasto 'F' se mappato come "toggle_fly")
	if event.is_action_pressed("toggle_fly"):
		is_flying = !is_flying
		if is_flying:
			velocity = Vector3.ZERO # Reset velocità quando inizi a volare

func _physics_process(delta):
	# GESTIONE GRAVITÀ
	if not is_on_floor() and not is_flying: # Applica gravità solo se non sei a terra E non stai volando
		velocity.y -= gravity * delta

	if sta_scrivendo:
		velocity = Vector3.ZERO
	else:
		# LOGICA DI MOVIMENTO
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
		
		if is_flying:
			# --- MOVIMENTO VOLO ---
			# In volo usiamo anche l'asse Y per salire e scendere
			var vertical_dir = 0.0
			if Input.is_action_pressed("jump"): # Usa il tasto salto per salire
				vertical_dir += 1
			if Input.is_action_pressed("move_down"): # Devi mappare un tasto (es. SHIFT o Q) come "move_down"
				vertical_dir -= 1
			
			# Applica velocità di volo (puoi anche usare lo sprint qui)
			var current_fly_speed = fly_speed
			if Input.is_action_pressed("sprint"):
				current_fly_speed *= 2.0
				
			velocity.x = direction.x * current_fly_speed
			velocity.z = direction.z * current_fly_speed
			velocity.y = vertical_dir * current_fly_speed
		else:
			# --- MOVIMENTO A TERRA (Originale) ---
			direction.y = 0
			var current_speed := walk_speed
			if Input.is_action_pressed("sprint"):
				current_speed = sprint_speed

			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = jump_velocity

			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed

	move_and_slide()

func _process(delta):
	var target_fov = normal_fov
	if Input.is_action_pressed("zoom"):
		target_fov = zoom_fov
	cam.fov = lerp(cam.fov, target_fov, zoom_speed * delta)
	
func show_prompt(value: bool):
	ui_hint.visible = value
