extends Control

@onready var heart_container = $Hearts/MarginContainer/HBoxContainer
@onready var spell_texture = $Spells/MarginContainer/TextureRect
@onready var energy_bar = $EnergyBar/MarginContainer/TextureProgressBar
@onready var stamina_bar = $StaminaBar/CenterContainer/MarginContainer/TextureProgressBar
var heart_scene: PackedScene = preload("res://scenes/entities/player/heart.tscn")
var fire_texture = preload("res://graphics/ui/fire.png")
var heal_texture = preload("res://graphics/ui/heal.png")

func setup(value: int) -> void:
	for i in value:
		var heart = heart_scene.instantiate()
		heart_container.add_child(heart)
		#
		heart.change_alpha_tween(1.0)
		#
		await get_tree().create_timer(0.3).timeout

func update_health(value: int, direction: int) -> void:
	#remove all heart
	for child in heart_container.get_children():
		child.queue_free()
	if direction < 0:
		for i in value:
			var heart = heart_scene.instantiate()
			heart_container.add_child(heart)
		var extra_heart = heart_scene.instantiate()
		heart_container.add_child(extra_heart)
		extra_heart.change_alpha_tween(0.0)
	else:
		for i in value - 1:
			var heart = heart_scene.instantiate()
			heart_container.add_child(heart)
		var extra_heart = heart_scene.instantiate()
		heart_container.add_child(extra_heart)
		extra_heart.change_alpha_tween(1.0)

func update_spell(spells, current_spell) -> void:
	match current_spell:
		spells.FIREBALL:
			spell_texture.texture =  fire_texture
		_:
			spell_texture.texture =  heal_texture
	#if current_spell == spells.FIREBALL:
		#spell_texture.texture =  fire_texture
	#if current_spell == spells.HEAL:
		#spell_texture.texture =  heal_texture	

func update_energy(value: int) -> void:
	energy_bar.value = value

func update_stamina(current: int, target: int) -> void:
	var tween = create_tween()
	tween.tween_method(change_stamina, current, target, 0.25)

func change_stamina(value: int) -> void:
	stamina_bar.value = value

func change_stamina_alpha_tween(value: float)-> void:
	var tween = create_tween()
	tween.tween_method(change_stamina_alpha, 1.0 - value, value, 0.25)

func change_stamina_alpha(value: float) -> void:
	stamina_bar.modulate.a = value
