varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D u_scene_tex; 
uniform sampler2D u_distort_tex; 
uniform float u_force;

void main()
{
    vec4 distort_data = texture2D(u_distort_tex, v_vTexcoord);
    
    vec2 distortion_offset = vec2(0.0);
    if (distort_data.a > 0.0) {
        // МЕНЯЕМ .rg на .gr, чтобы повернуть направление волны на 90 градусов
        distortion_offset = (distort_data.gr - 0.5) * 2.0;
    }
    
    float current_strength = distort_data.a * u_force;
    vec2 distorted_uv = v_vTexcoord + (distortion_offset * current_strength);
    
    // Защита от заворота текстуры за края экрана
    distorted_uv = clamp(distorted_uv, 0.0, 1.0);
    
    gl_FragColor = v_vColour * texture2D(u_scene_tex, distorted_uv);
}