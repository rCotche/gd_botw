class_name Enemy
extends CharacterBody3D

@onready var move_state_machine = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var attack_animation = $AnimationTree.get_tree_root().get_node("AttackAnimation")
@onready var player = get_tree().get_first_node_in_group('Player')
@onready var skin = get_node('skin')

@export var walk_speed := 2.0
@export var notice_radius := 30.0
@export var attack_radius := 3.0

var rng = RandomNumberGenerator.new()

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
			velocity = Vector3(target_vec2.x, 0, target_vec2.y) * walk_speed
			move_state_machine.travel('walk')
		else:
			velocity = Vector3.ZERO
			move_state_machine.travel('idle')
		#move the enemy
		move_and_slide()
