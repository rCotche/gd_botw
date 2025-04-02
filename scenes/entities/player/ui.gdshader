shader_type canvas_item;

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
	// Called for every pixel the material is visible on.
}