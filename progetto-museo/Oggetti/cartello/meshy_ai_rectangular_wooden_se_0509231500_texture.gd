extends Node3D

var player_near = false

@export var titolo := "Titolo"
@export_multiline var descrizione := "Testo del cifrario"
var ui
var player
func _ready():
	ui = get_tree().current_scene.get_node("UI")
	player = get_tree().current_scene.find_child("DesktopPlayer", true, false)

	

#func _process(delta):
#	if player_near and Input.is_action_just_pressed("interact"):
#		get_node("/root/Main/UI").show_info(titolo, descrizione)

#func _on_area_3d_body_entered(body):
#	if body.name == "Player":
#		player_near = true

func _on_area_3d_body_exited(body):
	if body.name == "Player":
		player_near = false

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		ui.show_info("TEST", "FUNZIONA")

func _on_area_3d_body_entered(body):
	print("ENTRATO:", body.name)
	
	
