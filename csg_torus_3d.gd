extends CSGTorus3D

func _ready() -> void:
	#fonctionne avec un MeshInstance3D
	#35:31 sur le tuto
	#var material = mesh.surface_get_material(0)
	#material.albedo_color = Color.GREEN
	
	#print(self.material.get_instance_id())
	var material = self.material
	material.albedo_color = Color.GREEN

#quand je veux bouger un 3d object
# la plupart du temps je vais utiliser la fonction _physics_process
#car more accurate in physics
func _physics_process(delta: float) -> void:
	#rotate_y(0.1)
	rotation_degrees += Vector3(0,2.5,0)
	position += Vector3(1,0,0) * delta
	scale += Vector3(0.1,0.1,0.1) * delta
	outer_radius = 0.6
