extends Node3D

@export var titolo := "Cifrario di Playfair"
@export_multiline var descrizione := "Invece di cifrare una lettera alla volta, lavora su coppie di lettere. Usa una tabella 5×5 costruita con una parola chiave. Questo metodo rendeva più complicata l’analisi delle frequenze usata per rompere i cifrari più semplici."

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
