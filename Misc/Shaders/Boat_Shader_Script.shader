shader_type canvas_item;

//uniforms
uniform float wave_height;
uniform float freq;
uniform vec4 col : hint_color;
//vars
//vertex script
void vertex(){
	float d = 0.0-VERTEX.x;
	VERTEX.y += cos(2.0+TIME*freq)*wave_height*d;
}
//fragment script
void fragment() {
	COLOR.abrg = texture(TEXTURE , UV);
}
