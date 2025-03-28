class_name Enemy
extends CharacterBody3D

@onready var move_state_machine = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var attack_animation = $AnimationTree.get_tree_root().get_node("AttackAnimation")
@onready var player = get_tree().get_first_node_in_group('Player')
@onready var skin = get_node('skin')

@export var walk_speed := 2.0
@export var speed := walk_speed
var speed_modifier := 1.0
@export var notice_radius := 30.0
@export var attack_radius := 3.0

var rng = RandomNumberGenerator.new()
var squash_and_stretch := 1.0:
	set(value):
		squash_and_stretch = value
		#3:16:24
		var negative  = 1.0 + (1.0 - squash_and_stretch)
		skin.scale = Vector3(negative,squash_and_stretch,negative)

func move_to_player(delta: float) -> void:
	if position.distance_to(player.position) < notice_radius:
		#get la direction en le joueur et l'enenmie
		var target_dir = (player.position - position).normalized()
		var target_vec2 = Vector2(target_dir.x, target_dir.z)
		
		#get l'angle entre le joueur et l'enemie
		var target_angle = -target_vec2.angle() + PI/2
		#rotate the model to the player
		rotation.y = rotate_toward(rotation.y, target_angle, delta * 6.0)
		if position.distance_to(player.position) > attack_radius:
			#vitesse que l'enemie se dirige vers le joeur
			velocity = Vector3(target_vec2.x, 0, target_vec2.y) * speed * speed_modifier
			move_state_machine.travel('walk')
		else:
			velocity = Vector3.ZERO
			move_state_machine.travel('idle')
		#move the enemy
		move_and_slide()

func stop_movement(start_duration: float, end_duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "speed_modifier", 0.0, start_duration)
	tween.tween_property(self, "speed_modifier", 1.0, end_duration)

func hit() -> void:
	if not $Timers/InvulTimer.time_left:
		do_squash_and_stretch(1.2,0.15)
		$Timers/InvulTimer.start()

func do_squash_and_stretch(value: float, duration: float = 0.1) -> void:
	var tween = create_tween()
	tween.tween_property(self, "squash_and_stretch", value, duration)
	tween.tween_property(self, "squash_and_stretch", 1.0, duration * 1.8).set_ease(Tween.EASE_OUT)
