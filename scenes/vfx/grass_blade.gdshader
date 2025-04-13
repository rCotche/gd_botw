shader_type spatial;
render_mode cull_disabled;

uniform vec3 color: source_color;
uniform vec3 shadow_color: source_color;

//repeat_disable : Les coordonnées UV en dehors de la plage [0, 1]
//ne feront pas boucler la texture, mais seront probablement clampées aux bords.
uniform sampler2D curve_sampler: repeat_disable;
//repeat_enable : Les coordonnées UV hors de la plage [0, 1]
//feront répéter la texture, créant un effet de tile (carrelage).
//filter_linear : Le filtrage linéaire lisse la texture
//en interpolant entre plusieurs pixels,
//ce qui est utile pour éviter les effets de pixelisation ou de "staircase".
uniform sampler2D wind_sampler: repeat_enable, filter_linear;
uniform float wind_strength = 0.4;

void vertex() {
	vec2 world_pos = vec2(NODE_POSITION_WORLD.x, NODE_POSITION_WORLD.z);
	//get the curve avec curve_sampler
	//get la valeur par la hauteur UV.y
	float curve = texture(curve_sampler, vec2(UV.y,0.0)).x;
	//get the noise texture wind_sampler
	// world_pos get a point sur le texture
	// additionner avec le temps cela va faire avancer le point sur la texture
	//du coup le point sera alternativement
	//sur une partie blanche ou noir de la texture
	float wind  = texture(wind_sampler, world_pos * 0.08 + TIME * 0.05).x * curve;
	VERTEX += vec3(curve);
}

void fragment() {
	//comme dans la version visual shader, albedo est l'output
	//la "propriete" que je souhaite modifier
	
	//en haut de la feuille on pour la couleur la valeur : color
	//plus je descend j'obtiens pour la couleur la valeur : shadow_color * color
	ALBEDO = mix(color, shadow_color * color, UV.y);
}
