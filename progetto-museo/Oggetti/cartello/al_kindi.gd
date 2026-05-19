extends Node3D

@export var titolo := "Cifrario di Al Kindi"
@export_multiline var descrizione := "Non inventò un nuovo cifrario famoso, ma sviluppò il primo metodo scientifico per decifrare messaggi segreti. Studiando la frequenza delle lettere nelle lingue, riusciva a capire quali simboli corrispondevano alle lettere vere. È considerato uno dei padri della crittanalisi."

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
