// Godot 4.x
shader_type spatial;

render_mode cull_front, unshaded, depth_draw_always;

uniform float outline_size : hint_range(0.0, 0.2) = 0.03;
uniform vec4 outline_color : source_color = vec4(0.2, 0.8, 1.0, 1.0);
uniform float blink_speed : hint_range(0.0, 10.0) = 0.5;
uniform float min_intensity : hint_range(0.0, 1.0) = 0.3;

void vertex() {
    // Push the mesh outwards to create the outline "shell"
    VERTEX += NORMAL * outline_size;
}

void fragment() {
    // 0..1 pulsing factor
    float pulse = 0.5 + 0.5 * sin(mod(TIME * blink_speed * TAU, TAU));
    float intensity = mix(min_intensity, 1.0, pulse);

    ALBEDO = outline_color.rgb * intensity;
    ALPHA  = outline_color.a;
}