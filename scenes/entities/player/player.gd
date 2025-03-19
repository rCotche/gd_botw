extends CharacterBody3D

#@export var base_speed: float = 4.0
@export var base_speed := 4.0

var movement_input := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward")
	
	#movement_input est en 2d donc on es obliger de créer un Vector3
	velocity = Vector3(movement_input.x, 0, movement_input.y) * base_speed
	
	move_and_slide()
