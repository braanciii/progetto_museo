extends Node3D

@export var titolo := "Cifrario monoalfabetico medievale"
@export_multiline var descrizione := "In questo sistema ogni lettera viene sostituita sempre con un altro simbolo o lettera. Per esempio, A potrebbe diventare X e B potrebbe diventare M. Era più sicuro del cifrario di Cesare, ma con abbastanza pazienza poteva essere decifrato analizzando le lettere più usate."

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
