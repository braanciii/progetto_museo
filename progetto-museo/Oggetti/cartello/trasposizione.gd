extends Node3D

@export var titolo := "Cifrario a trasposizione meccanica"
@export_multiline var descrizione := "Qui le lettere non vengono cambiate, ma mescolate seguendo uno schema preciso, spesso con strumenti meccanici o griglie. Il messaggio contiene sempre le stesse lettere originali, ma in ordine diverso."

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
