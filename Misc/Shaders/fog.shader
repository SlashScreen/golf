shader_type spatial;
uniform sampler2D noise;

void vertex(){
	VERTEX.y = texture(noise,UV*(sin(TIME/50.0))).g;
}

void fragment(){
	ALPHA = texture(noise,UV*(sin(TIME/50.0))).g;
}