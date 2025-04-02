shader_type canvas_item;

//Uniform :
//Le mot-clé uniform permet de définir des variables accessibles
//et modifiables depuis l'extérieur du shader (par exemple via l'éditeur ou par script).
//Annotations (: source_color, : hint_range(...)) :
//Ces annotations servent à donner des indications à l'éditeur pour
//afficher ces propriétés de manière adaptée (sélecteur de couleur, slider, etc.).

//uniform vec3 color :
//Déclare une variable uniforme nommée color de type vec3 
//(un vecteur à trois composantes), souvent utilisé pour représenter une couleur
//(rouge, vert, bleu).
//: source_color :
//Ce label informe l'éditeur que cette variable représente une couleur source.
//L'éditeur pourra alors, par exemple, afficher un sélecteur de couleur.
//= vec3(1.0) :
//Définit la valeur par défaut à vec3(1.0), ce qui correspond à (1.0, 1.0, 1.0)
 //– soit la couleur blanche.
uniform vec3 color : source_color = vec3(1.0);
//: hint_range(0.0, 1.0) :
//Le hint_range indique à l'éditeur que cette variable doit être manipulée via
 //une interface (comme un slider) dont la plage va de 0.0 à 1.0. 
//Cela permet de contrôler précisément sa valeur dans l'éditeur.
//= 0.0 :
//La valeur par défaut est 0.0.
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	//give the color of every single pixel of this graphic
	vec4 texture_color = texture(TEXTURE, UV);
	//mix la couleur que j'obtiens de texture_color avec la couleur du uniform
	//the amount we r getting from the color is determined by progress
	COLOR.rgb = mix(texture_color.rgb, color, progress);
	COLOR.a = alpha * texture_color.a;
}