extends PathFollow3D

func _process(delta: float) -> void:
	progress += 40 * delta
