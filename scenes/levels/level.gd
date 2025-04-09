class_name Level
extends Node3D

var fireball_scene: PackedScene = preload("res://scenes/vfx/fireball.tscn")
const scenes = {
	'dungeon':"res://scenes/levels/dungeon.tscn",
	'overworld':"res://scenes/levels/overworld.tscn",
}

func _ready() -> void:
	for entity in $Entities.get_children():
		if entity.has_signal('cast_spell'):
			entity.connect('cast_spell', create_fireball)

func create_fireball(_type: String, pos: Vector3, direction: Vector2, size: float) -> void:
	var fireball = fireball_scene.instantiate()
	$Projectiles.add_child(fireball)
	fireball.global_position = pos
	fireball.direction = direction
	fireball.setup(size)

func switch_level_deferred(target: String) -> void:
	#needed to make sur we dont mess with physics lorsque l'on change de scene
	call_deferred('switch_level', target)

func switch_level(target: String) -> void:
	get_tree().change_scene_to_file(scenes[target])
