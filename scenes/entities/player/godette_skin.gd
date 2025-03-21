extends Node3D

@onready var move_state_machine = $AnimationTree.get("parameters/MoveStateMachine/playback")

func set_move_state(state_name: String) -> void:
	move_state_machine.travel(state_name)

func attack() -> void:
	#set(): Assigns value to the given property
	#play the animation once
	#$AnimationTree.set("parameters/AttackOneShot/request", true) #mm chose
	$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func defend() -> void:
	var tween = create_tween()
	tween.tween_method(_defend_change, 1.0 - float(forward), float(forward), 0)

func _defend_change(value: bool) -> void:
	$AnimationTree.set("parameters/ShieldBlend/blend_amount", value)
