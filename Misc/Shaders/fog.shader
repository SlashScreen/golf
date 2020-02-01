shader_type spatial;
uniform sampler2D noise;

void vertex(){
	float height = texture(noise,UV*(sin(TIME/50.0))).g;
	VERTEX.y = height;
}

void fragment(){
	ALPHA = texture(noise,UV*(sin(TIME/50.0))).g;
	NORMALMAP = texture(noise,UV*(sin(TIME/50.0))).rgb;
}