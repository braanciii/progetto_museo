extends Node3D

@export var titolo := "Enigma machine"
@export_multiline var descrizione := "Era una macchina elettromeccanica usata dalla Germania nazista. Ogni tasto premuto cambiava automaticamente il modo di cifrare la lettera successiva. Sembrava impossibile da decifrare, ma gli Alleati riuscirono a romperne il codice, influenzando la guerra."

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
