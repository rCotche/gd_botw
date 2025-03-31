extends Enemy

func _ready() -> void:
	attack_radius = 10.0

func _physics_process(delta: float) -> void:
	move_to_player(delta)

func range_attack_animation() -> void:
	stop_movement(1.5,1.5)
	$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _on_attack_timer_timeout() -> void:
	$Timers/AttackTimer.wait_time = rng.randf_range(4.0,5.5)
	if position.distance_to(player.position) < attack_radius:
		range_attack_animation()

func shoot_fireball_skeleton_mage() -> void:
	var direction = (player.position - position).normalized()
	var dir_2d = Vector2(direction.x, direction.z)
	var pos = $skin/Rig/Skeleton3D/BoneAttachment3D/wand2/wand/Marker3D.global_position
	cast_spell.emit('fireball', pos, dir_2d, 1.0)
