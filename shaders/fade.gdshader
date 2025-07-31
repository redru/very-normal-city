shader_type spatial;
render_mode blend_mix, depth_draw_opaque, diffuse_burley, specular_schlick_ggx;

uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform vec3 color : source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
	ALBEDO = color;
	ALPHA = alpha;
}
