extends Node3D

@export var titolo := "Cifrario di Lorenz"
@export_multiline var descrizione := "Era una macchina ancora più complessa di Enigma, usata per comunicazioni militari di alto livello. Funzionava con telescriventi e generava cifrature molto sofisticate. Gli inglesi svilupparono alcuni dei primi computer per riuscire a decifrarla."

var player_near = false

func _on_area_3d_body_entered(body):
	if body.name == "DesktopPlayer":
		player_near = true
		body.show_prompt(true)


func _on_area_3d_body_exited(body):
	if body.name == "DesktopPlayer":
		player_near = false
		body.show_prompt(false)


func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):
		var ui = get_tree().current_scene.get_node("UI")
		ui.show_info(titolo, descrizione)
