extends Area3D

var direction: Vector2
const speed := 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector3(direction.x, 0 , direction.y) * speed * delta


func _on_body_entered(body: Node3D) -> void:
	if 'hit' in body:
		body.hit()
		queue_free()
