extends Enemy

func _physics_process(delta: float) -> void:
	move_to_player(delta)

func range_attack_animation() -> void:
	stop_movement(1.5,1.5)
	$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _on_attack_timer_timeout() -> void:
	$Timers/AttackTimer.wait_time = rng.randf_range(4.0,5.5)
	if position.distance_to(player.position) < 15.0:
		range_attack_animation()
