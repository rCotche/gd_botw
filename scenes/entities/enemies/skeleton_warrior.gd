extends Enemy

func _ready() -> void:
	attack_radius = 1.5

func _physics_process(delta: float) -> void:
	move_to_player(delta)

func melee_attack_animation() -> void:
	$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _on_attack_timer_timeout() -> void:
	$Timers/AttackTimer.wait_time = rng.randf_range(2.0,3.0)
	if position.distance_to(player.position) < attack_radius:
		melee_attack_animation()

func can_damage(value: bool) -> void:
	$skin/Rig/Skeleton3D/BoneAttachment3D/Bone.can_damage = value
