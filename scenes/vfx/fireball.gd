extends Area3D

var direction: Vector2
const speed := 9.0

func _ready() -> void:
	scale = Vector3(0.1,0.1,0.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector3(direction.x, 0 , direction.y) * speed * delta

func _on_body_entered(body: Node3D) -> void:
	if 'hit' in body:
		body.hit()
		queue_free()

func setup(size: float) ->void:
	$FireballMesh.rotation.y = -(direction.angle() + PI/2) + PI
	var tween =create_tween()
	tween.tween_property(self, "scale", Vector3.ONE * size, 0.5)
