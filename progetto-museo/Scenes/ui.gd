extends CanvasLayer

@onready var panel = $Panel
@onready var title = $Panel/Title
@onready var description = $Panel/Description
@onready var close_button = $Panel/CloseButton

var player

func _ready():
	panel.visible = false
	close_button.pressed.connect(_on_close_pressed)

	player = get_tree().current_scene.find_child("DesktopPlayer", true, false)

func show_info(titolo, testo):
	title.text = titolo
	description.text = testo

	panel.visible = true
	player.sta_scrivendo = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_close_pressed():
	panel.visible = false
	player.sta_scrivendo = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
