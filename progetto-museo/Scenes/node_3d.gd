extends Node3D

func _ready():
	var xr_interface := XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized() == false:
		xr_interface.initialize()

	if xr_interface and xr_interface.is_initialized():
		get_viewport().use_xr = true
