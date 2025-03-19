extends Node3D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#print(event.relative)
		#rotation.y += event.relative.x *0.005
		rotate_from_vector(event.relative * 0.005)

func rotate_from_vector(v: Vector2):
	if v.length() == 0:return
	rotation.y += v.x
	#invert camera movement
	#rotation.y -= v.x
