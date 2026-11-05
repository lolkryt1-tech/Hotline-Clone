varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    vec4 base_color = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // МАКСИМАЛЬНЫЙ ШЛЕЙФ: 0.98 задержит след на экране очень надолго!
    base_color.a *= 0.98; 
    
    gl_FragColor = v_vColour * base_color;
}
