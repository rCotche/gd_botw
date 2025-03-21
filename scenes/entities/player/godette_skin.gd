extends Node3D

@onready var move_state_machine = $AnimationTree.get("parameters/MoveStateMachine/playback")

func set_move_state(state_name: String) -> void:
	move_state_machine.travel(state_name)

func attack() -> void:
	#set(): Assigns value to the given property
	#play the animation once
	#$AnimationTree.set("parameters/AttackOneShot/request", true) #mm chose
	$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
