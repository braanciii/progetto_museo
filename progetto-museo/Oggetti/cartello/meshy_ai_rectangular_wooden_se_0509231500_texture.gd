extends Node3D

@export var titolo := "Cifrario di Cesare"
@export_multiline var descrizione := "È uno dei cifrari più semplici: ogni lettera del messaggio viene spostata di un certo numero di posti nell’alfabeto. Per esempio, con uno spostamento di 3, A diventa D e B diventa E. Era usato da Giulio Cesare per inviare messaggi segreti ai suoi generali."

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
