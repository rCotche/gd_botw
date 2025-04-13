shader_type spatial;
render_mode cull_disabled;

uniform sampler2D noise_sampler: filter_linear_mipmap, repeat_enable;
uniform sampler2D gradient_sampler: filter_linear, source_color;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}
//test
vec3 fresnel_glow(float amount, float intensity, vec3 color, vec3 normal, vec3 view)
{
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void fragment() {
	float noise = texture(noise_sampler, UV - vec2(0.0, TIME)).x;
	vec3 gradient = texture(gradient_sampler, vec2(UV.y,0.0)).rgb;
	ALBEDO = gradient;
	vec3 fresnel_color = vec3(0.1, 0.9, 0.0);
	EMISSION = gradient + step(0.25, fresnel_glow(4, 4.5, fresnel_color, NORMAL, VIEW));
	//EMISSION = gradient + step(0.25, fresnel(2.0, NORMAL, VIEW)* gradient);
	//plus on est vers la droite plus la valeur de : noise - UV.y est bas
	//donc the cutoof point will be lower
	ALPHA = step(-0.15, noise - UV.y);
}
