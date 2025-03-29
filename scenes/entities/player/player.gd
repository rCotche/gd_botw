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
var speed_modifier := 1.0

var movement_input := Vector2.ZERO
var defend := false:
	set(value):
		#je veux me defendre
		if not defend and value:
			skin.defend(true)
		if defend and not value:
			skin.defend(false)
		defend = value

#sword ou wand
var weapon_active := true

@onready var camera = $CameraController/Camera3D

func _ready() -> void:
	skin.switch_weapon(weapon_active)

#basic movement influence by a camera
func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic(delta)
	ability_logic()
	#if Input.is_action_just_pressed("ui_accept"):
		#hit()
	move_and_slide()

func move_logic(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	#1. Current movement speed du player
	var velocity_2d := Vector2(velocity.x, velocity.z)
	
	var is_running:bool = Input.is_action_pressed("run")
	
	#2. est ce que il y a un input
	if movement_input != Vector2.ZERO:
		
		var speed = run_speed if is_running else base_speed
		#while blocking le player est plus lent
		speed = defend_speed if defend else speed
		
		#2.1 slowly accelerating from iur current speed vers la direction de l'input
		velocity_2d += movement_input * speed * delta * 8.0
		#tous les vecteur ont la fonction limit_length
		#2.2 set a maximum speed
		velocity_2d = velocity_2d.limit_length(speed) * speed_modifier
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
			do_squash_and_stretch(1.2, 0.15)
	else:
		skin.set_move_state('Jump_Idle')
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta

func ability_logic() -> void:
	#actual attack
	if Input.is_action_just_pressed("ability"):
		if weapon_active:
			skin.attack()
		else:
			skin.spell_cast()
			stop_movement(0.3,0.8)
	
	#defend/block
	defend = Input.is_action_pressed("block")
	
	#switch weapon/magic
	if Input.is_action_just_pressed("switch weapon") and not skin.attacking:
		weapon_active = not weapon_active
		skin.switch_weapon(weapon_active)
		do_squash_and_stretch(1.2, 0.15)

func stop_movement(start_duration: float, end_duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "speed_modifier", 0.0, start_duration)
	tween.tween_property(self, "speed_modifier", 1.0, end_duration)

func hit() -> void:
	var timer = skin.get_node('InvulTimer')
	if not timer.time_left:
		skin.hit()
		stop_movement(0.3,0.3)
		timer.start()

func do_squash_and_stretch(value: float, duration: float = 0.1) -> void:
	var tween = create_tween()
	tween.tween_property(skin, "squash_and_stretch", value, duration)
	tween.tween_property(skin, "squash_and_stretch", 1.0, duration * 1.8).set_ease(Tween.EASE_OUT)
#
