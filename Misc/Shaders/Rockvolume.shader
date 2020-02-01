shader_type spatial;
render_mode unshaded;
uniform float magnitude = .1;

void fragment() {
	vec2 newUV = vec2(SCREEN_UV.x,SCREEN_UV.y+(sin(TIME)*magnitude));
    vec3 c = texture(SCREEN_TEXTURE, newUV, 0.0).rgb;
    ALBEDO.rgb = c;
}