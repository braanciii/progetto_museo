extends MultiMeshInstance3D

@export var area_size := Vector2(50, 50) # dimensione prato
@export var density := 8.0 # più alto = più erba

func _ready():
	var mesh_resource = self.multimesh.mesh
	
	if mesh_resource == null:
		push_error("Assegna prima il mesh dell'erba nel MultiMesh!")
		return
	
	var count = int(area_size.x * area_size.y * density)
	multimesh.instance_count = count
	
	var i = 0
	
	for x in range(area_size.x * density):
		for z in range(area_size.y * density):
			if i >= count:
				return
			
			var pos = Vector3(
				(x / density) - area_size.x / 2.0 + randf_range(-0.3, 0.3),
				0,
				(z / density) - area_size.y / 2.0 + randf_range(-0.3, 0.3)
			)
			
			var transform = Transform3D()
			transform.origin = pos
			
			# leggera variazione random
			transform.basis = Basis().rotated(Vector3.UP, randf() * TAU)
			transform.basis = transform.basis.scaled(Vector3.ONE * randf_range(0.8, 1.2))
			
			multimesh.set_instance_transform(i, transform)
			i += 1
