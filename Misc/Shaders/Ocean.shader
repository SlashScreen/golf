//Head
shader_type spatial;
render_mode specular_toon;
//Variables
uniform sampler2D noise;
uniform vec4 main_color : hint_color;
uniform vec4 foam_color : hint_color;
uniform float near = 0.15;
uniform float far = 300.0;
uniform float intersection_max_threshhold = .3;
uniform float wave_height = 2.0;
uniform float wave_speed = 25.0;
//Custom Functions
float linearize(float c_depth) {
    c_depth = 2.0 * c_depth - 1.0; // bring to a 0-1 value
    return near * far / (far + c_depth * (near - far)); //un-logify it
}
//Main Loops
void vertex(){
	VERTEX.y = texture(noise,UV*(sin(TIME/wave_speed))).g*wave_height;
}

void fragment() {
	//float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	//RIM = 0.2;
	//METALLIC = 0.0;
	//ROUGHNESS = 0.01;
	
	//ALBEDO = vec3(0.1, 0.3, 0.5) + (0.1 * fresnel);
	
	float zdepth = linearize(texture(DEPTH_TEXTURE, SCREEN_UV).x);
	float zpos = linearize(FRAGCOORD.z);
	float diff = zdepth - zpos;
	//Mix colors: step is within threshhold
	vec4 col = mix(foam_color,main_color,step(intersection_max_threshhold,diff));
	ALBEDO = col.rgb;
	
	NORMALMAP = texture(noise,UV*(sin(TIME/wave_speed))).rgb;
}