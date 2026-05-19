extends Node3D

@export var titolo := "Cifrario di Vigenère"
@export_multiline var descrizione := "Usa più alfabeti diversi invece di uno solo. La sostituzione cambia continuamente grazie a una parola chiave segreta. Per secoli fu considerato quasi impossibile da decifrare ed era chiamato “il cifrario indecifrabile”."

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
