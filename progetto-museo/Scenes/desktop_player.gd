extends CharacterBody3D

@export var speed := 4.0
@export var mouse_sens := 0.002

var yaw := 0.0
var pitch := 0.0

@onready var cam: Camera3D = $Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sens
		pitch -= event.relative.y * mouse_sens
		pitch = clamp(pitch, -1.2, 1.2)
		rotation.y = yaw
		cam.rotation.x = pitch

func _physics_process(delta):
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("move_forward"): input_dir.z -= 1
	if Input.is_action_pressed("move_back"):    input_dir.z += 1
	if Input.is_action_pressed("move_left"):    input_dir.x -= 1
	if Input.is_action_pressed("move_right"):   input_dir.x += 1

	input_dir = input_dir.normalized()
	var dir = (global_transform.basis * input_dir)
	dir.y = 0
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	move_and_slide()

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
