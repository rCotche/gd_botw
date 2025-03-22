extends CharacterBody3D

#jump
@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
# source: https://youtu.be/IOe1aGY6hXA?feature=shared

@onready var skin = $GodetteSkin

#@export var base_speed: float = 4.0
@export var base_speed := 4.0
@export var run_speed := 8.0
@export var defend_speed := 2.0

var movement_input := Vector2.ZERO
var defend := false:
	set(value):
		#je veux me defendre
		if not defend and value:
			skin.defend(true)
		if defend and not value:
			skin.defend(false)
		defend = value

@onready var camera = $CameraController/Camera3D

#basic movement influence by a camera
func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic(delta)
	ability_logic()
	move_and_slide()

func move_logic(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	#1. Current movement speed du player
	var velocity_2d := Vector2(velocity.x, velocity.z)
	
	var is_running:bool = Input.is_action_pressed("run")
	
	#2. est ce que il y a un input
	if movement_input != Vector2.ZERO:
		
		var speed = run_speed if is_running else base_speed
		speed = defend_speed if defend else speed
		
		#2.1 slowly accelerating from iur current speed vers la direction de l'input
		velocity_2d += movement_input * speed * delta
		#tous les vecteur ont la fonction limit_length
		#2.2 set a maximum speed
		velocity_2d = velocity_2d.limit_length(speed)
		#Rappel velocity c'est un vecteur 3d
		#2.3 updating velocity to get a new movement speed
		velocity.x = velocity_2d.x
		velocity.z = velocity_2d.y
		skin.set_move_state('Running')
		
		#rotate godette model
		#movement_input.angle() est en radian
		var target_angle = -movement_input.angle() + PI/2
		#rotate_toward (rotation de départ, rotation que l'on souhaite, temps)
		skin.rotation.y = rotate_toward(skin.rotation.y, target_angle, 6.0 * delta)
		
	#3 pas de input
	else:
		#permet de ralentir le perso lorsqu'il y a pas d'input
		#3.1 get our current speed and change it to zero
		#base_speed * 4.0 * delta c'est la vitesse à laquelle
		#la vitesse du player va atteindre 0
		velocity_2d = velocity_2d.move_toward(Vector2.ZERO, base_speed * 4.0 * delta)
		#3.2 updating velocity to get a new movement speed
		velocity.x = velocity_2d.x
		velocity.z = velocity_2d.y
		skin.set_move_state('Idle')

func jump_logic(delta: float) -> void:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity
	else:
		skin.set_move_state('Jump_Idle')
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta

func ability_logic() -> void:
	if Input.is_action_just_pressed("ability"):
		skin.attack()
	defend = Input.is_action_pressed("block")
#
