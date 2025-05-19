shader_type spatial;

uniform vec4 albedo_color : hint_color = vec4(1.0, 0.5, 0.0, 1.0); // Cor do eixo (como exemplo, laranja)
uniform float outline_size : hint_range(0.0, 1.0) = 0.03; // Tamanho da borda
uniform vec4 outline_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0); // Cor da borda (preto, pode ser ajustado)
uniform float glow_intensity : hint_range(0.0, 5.0) = 2.0; // Intensidade do brilho

void fragment() {
	// Cor base do objeto
	vec4 base_color = albedo_color;

	// Determinando a borda, baseada na normal
	float edge_factor = 1.0 - length(fwidth(VERTEKTX.normal)); 

	// Cor da borda
	vec4 glow_color = outline_color * edge_factor * outline_size;
	
	// Aplicar brilho com base na intensidade
	glow_color *= glow_intensity;

	// Combine a cor da borda e o brilho com a cor base
	vec4 final_color = mix(base_color, glow_color, glow_color.a);
	
	// Definir a cor final do pixel
	ALBEDO = final_color.rgb;
	ALPHA = final_color.a;
}
