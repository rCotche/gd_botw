extends CharacterBody3D

#jump
@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
# source: https://youtu.be/IOe1aGY6hXA?feature=shared

#@export var base_speed: float = 4.0
@export var base_speed := 4.0

var movement_input := Vector2.ZERO

@onready var camera = $CameraController/Camera3D

#basic movement influence by a camera
func _physics_process(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	
	#jump
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_velocity
	#var gravity
	#if velocity.y > 0.0:
		#gravity = jump_gravity
	#else:
		#gravity = fall_gravity
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta
	
	move_and_slide()
