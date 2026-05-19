extends Node3D

@export var titolo := "Scitala Spartana"
@export_multiline var descrizione := "Era un bastone attorno a cui si avvolgeva una striscia di pelle o carta. Il messaggio veniva scritto lungo il bastone; una volta srotolata la striscia, le lettere sembravano senza senso. Solo chi aveva un bastone della stessa dimensione poteva leggere il testo corretto."

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
