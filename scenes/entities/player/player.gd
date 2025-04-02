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

@onready var camera = $CameraController/Camera3D
@onready var ui = $UI

var last_movement_input := Vector2(0,1)
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
var weapon_active := true:
	set(value):
		weapon_active = value
		if weapon_active:
			ui.get_node("Spells").hide()
		else:
			ui.get_node("Spells").show()
var health: int = 5:
	set(value):
		ui.update_health(value, value - health)
		health = value
		if health <=0:
			get_tree().quit()
var energy: int = 100:
	set(value):
		energy = min(100, value)
		ui.update_energy(energy)
var stamina: int = 100:
	set(value):
		#attention: ordre a son importance
		ui.update_stamina(stamina, value)
		if stamina == 100 and value < 100:
			#visible
			ui.change_stamina_alpha_tween(1.0)
		if value == 100:
			#invisible
			ui.change_stamina_alpha_tween(0.0)
		stamina = clamp(value, 0, 100)

enum spells {FIREBALL, HEAL}
var current_spell = spells.FIREBALL

signal cast_spell(type: String, pos: Vector3, direction:Vector2, size: float)

func _ready() -> void:
	weapon_active = true
	skin.switch_weapon(weapon_active)
	ui.setup(health)

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
		
		#last_movement_input = movement_input
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
	if movement_input:
		last_movement_input = movement_input.normalized()

func jump_logic(delta: float) -> void:
	if is_on_floor():
		if Input.is_action_just_pressed("jump") and stamina >= 20:
			stamina -= 20
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
			if energy >= 20:
				skin.spell_cast()
				stop_movement(0.3,0.8)
				energy -= 20
	
	#defend/block
	defend = Input.is_action_pressed("block")
	
	#switch weapon/magic
	if Input.is_action_just_pressed("switch weapon") and not skin.attacking:
		weapon_active = not weapon_active
		skin.switch_weapon(weapon_active)
		do_squash_and_stretch(1.2, 0.15)
	if Input.is_action_just_pressed("switch spell") and not skin.attacking:
		#int(current_spell) convertit la valeur de current_spell (qui est déjà un entier dans ce cas) en entier.
		#Par exemple, si current_spell vaut spells.FIREBALL (c'est-à-dire 0), alors int(current_spell) renvoie 0.
		#
		#(int(current_spell) + 1) incrémente la valeur actuelle de 1.
		#Le modulo % len(spells) permet de revenir à 0 une fois que l'on atteint la fin de l'énumération.
		#Dans notre exemple avec deux sorts, si current_spell vaut 0, alors (0 + 1) % 2 renvoie 1. Si current_spell vaut 1, alors (1 + 1) % 2 renvoie 0.
		#
		#spells.keys() renvoie un tableau contenant les clés de l’énumération. Dans ce cas, on obtient probablement ["FIREBALL", "HEAL"].
		#En indexant ce tableau avec l'indice calculé précédemment, on sélectionne le nom du sort suivant.
		#
		#Finalement, spells[...] utilise le nom obtenu pour récupérer la valeur associée dans l’énumération.
		current_spell = spells[spells.keys()[(int(current_spell) + 1) % len(spells)]]
		ui.update_spell(spells, current_spell)

func stop_movement(start_duration: float, end_duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "speed_modifier", 0.0, start_duration)
	tween.tween_property(self, "speed_modifier", 1.0, end_duration)

func hit() -> void:
	if not $Timers/InvulTimer.time_left:
		skin.hit()
		stop_movement(0.3,0.3)
		health -= 1
		$Timers/InvulTimer.start()

func do_squash_and_stretch(value: float, duration: float = 0.1) -> void:
	var tween = create_tween()
	tween.tween_property(skin, "squash_and_stretch", value, duration)
	tween.tween_property(skin, "squash_and_stretch", 1.0, duration * 1.8).set_ease(Tween.EASE_OUT)

func shoot_magic(pos: Vector3) ->void:
	if current_spell == spells.FIREBALL:
		cast_spell.emit('fireball', pos, last_movement_input, 1.0)
	if current_spell == spells.HEAL:
		health += 1
	#match current_spell:
		#spells.FIREBALL:
			#cast_spell.emit('fireball', pos, last_movement_input, 1.0)
		#_:
			#health += 1

func _on_energy_recovery_timer_timeout() -> void:
	energy += 1


func _on_stamina_recovery_timer_timeout() -> void:
	stamina += 1
