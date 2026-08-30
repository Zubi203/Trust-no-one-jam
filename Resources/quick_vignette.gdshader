shader_type canvas_item;

uniform float intensity : hint_range(0.0, 10.0) = 0.6;
uniform float softness : hint_range(0.0, 1.0) = 0.3;
uniform vec3 color : source_color = vec3(0.0, 0.0, 0.0);  // Black

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV - vec2(0.5);
    float dist = length(uv);
    
    // vignette: 1 at center, 0 at edges
    float vignette = 1.0 - smoothstep(0.0, 0.5 + softness, dist);
    vignette = mix(1.0, vignette, intensity);
    
    vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
    
    // Darken edges (mix with black)
    vec3 final_color = mix(color, screen.rgb, vignette);
    
    COLOR = vec4(final_color, screen.a);
}