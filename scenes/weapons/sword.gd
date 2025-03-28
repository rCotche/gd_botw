extends Node3D

var can_damage := false

func _process(_delta: float) -> void:
	if can_damage:
		var collider = $RayCast3D.get_collider()
		#si collider exist et
		#si l'objet avec lequel sword collide with a la fonction hit
		#alors appel la fonction hit
		if collider and 'hit' in collider:
			collider.hit()
