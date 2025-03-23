extends Node3D

@onready var move_state_machine = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var attack_state_machine = $AnimationTree.get("parameters/AttackStateMachine/playback")
@onready var extra_animation = $AnimationTree.get_tree_root().get_node("ExtraAnimation")

#func _ready() -> void:
	#print(extra_animation)

var attacking := false
var squash_and_stretch := 1.0:
	set(value):
		squash_and_stretch = value
		#3:16:24
		var negative  = 1.0 + (1.0 - squash_and_stretch)
		scale = Vector3(negative,squash_and_stretch,negative)

func set_move_state(state_name: String) -> void:
	move_state_machine.travel(state_name)

func attack() -> void:
	if not attacking:
		attack_state_machine.travel('Slice' if $SecondAttackTimer.time_left else 'Chop')
		#set(): Assigns value to the given property
		#play the animation once
		#$AnimationTree.set("parameters/AttackOneShot/request", true) #mm chose
		$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func attack_toggle(value: bool) -> void:
	attacking = value

func defend(forward: bool) -> void:
	var tween = create_tween()
	tween.tween_method(_defend_change, 1.0 - float(forward), float(forward), 0.25)

func _defend_change(value: bool) -> void:
	$AnimationTree.set("parameters/ShieldBlend/blend_amount", value)

func switch_weapon(weapon_active: bool) -> void:
	if weapon_active:
		$Rig/Skeleton3D/RightHandSlot/sword_1handed2.show()
		$Rig/Skeleton3D/RightHandSlot/wand2.hide()
	else:
		$Rig/Skeleton3D/RightHandSlot/sword_1handed2.hide()
		$Rig/Skeleton3D/RightHandSlot/wand2.show()

func spell_cast() -> void:
	if not attacking:
		#change the extra animation to spellcast shoot
		extra_animation.animation = "Spellcast_Shoot"
		$AnimationTree.set("parameters/ExtraOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func hit() -> void:
	#change the extra animation to hit_A
	extra_animation.animation = "Hit_A"
	$AnimationTree.set("parameters/ExtraOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	#cancel attack animation
	$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	attacking = false
