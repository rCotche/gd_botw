extends TextureRect


func change_alpha_tween(target: float) -> void:
	var tween = create_tween()
	tween.tween_method(change_alpha, 1.0 - target, target, 0.4)

func change_alpha(value: float) -> void:
	material.set_shader_parameter('alpha', value)
	material.set_shader_parameter('progress', 1.0 - value)
