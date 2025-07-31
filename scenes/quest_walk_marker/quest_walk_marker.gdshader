shader_type spatial;

render_mode diffuse_lambert, specular_schlick_ggx, vertex_lighting, shadows_disabled, ambient_light_disabled, unshaded, cull_disabled, depth_draw_opaque, depth_test_disabled, blend_mix;

uniform float border_width : hint_range(0.0, 0.5, 0.01) = 0.02;
uniform float blink_speed : hint_range(0.1, 10.0, 0.1) = 1.0;
uniform vec3 border_color : source_color = vec3(0.0, 0.5, 1.0);
uniform float border_intensity : hint_range(1.0, 5.0, 0.1) = 2.0;

varying vec2 uv_coords;

void vertex() {
	uv_coords = UV;
}

void fragment() {
	// Get distance from edges
	float dist_left = uv_coords.x;
	float dist_right = 1.0 - uv_coords.x;
	float dist_top = uv_coords.y;
	float dist_bottom = 1.0 - uv_coords.y;

	// Find minimum distance to any edge
	float min_dist = min(min(dist_left, dist_right), min(dist_top, dist_bottom));

	// Create border mask
	float border_mask = 1.0 - smoothstep(0.0, border_width, min_dist);

	// Create blinking effect
	float blink = 0.5 + 0.5 * sin(mod(TIME * blink_speed * TAU, TAU)); // Oscillates between 0 and 1

	// Apply blinking to border
	float final_border = border_mask * blink;

	// Set color
	ALBEDO = border_color * border_intensity;
	ALPHA = final_border;

	// Make sure we have proper transparency
	if (ALPHA < 0.01) {
		discard;
	}
}