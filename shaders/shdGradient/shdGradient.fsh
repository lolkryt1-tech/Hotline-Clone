varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 u_color_top;
uniform vec3 u_color_bot;
uniform vec3 u_color_scan;
uniform float u_pulse;

void main()
{
    vec4 tex_color = texture2D(gm_BaseTexture, v_vTexcoord);
    if (tex_color.a < 0.1) discard;
    
    float y = v_vTexcoord.y;
    vec3 base_color = mix(u_color_top, u_color_bot, y);
    
    float scan_pos = fract(u_pulse);
    float scan_width = 0.08;
    float dist = abs(y - scan_pos);
    float scan_intensity = smoothstep(scan_width, 0.0, dist);
    
    float fade_top = smoothstep(0.0, 0.15, scan_pos); 
    float fade_bot = smoothstep(1.0, 0.85, scan_pos); 
    scan_intensity *= (fade_top * fade_bot);
    
    vec3 final_color = mix(base_color, u_color_scan, scan_intensity);
    
    gl_FragColor = vec4(final_color, tex_color.a * v_vColour.a);
}