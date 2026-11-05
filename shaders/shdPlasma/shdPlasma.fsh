varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;
uniform vec2 u_resolution;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main()
{
    vec2 uv = v_vTexcoord;
    uv.x *= u_resolution.x / u_resolution.y;
    
    // Искажение
    vec2 q = vec2(0.0);
    q.x = fbm(uv + 0.05 * u_time);
    q.y = fbm(uv + vec2(1.0, 1.0));
    
    vec2 r = vec2(0.0);
    r.x = fbm(uv + 1.0 * q + vec2(1.7, 9.2) + 0.15 * u_time);
    r.y = fbm(uv + 1.0 * q + vec2(8.3, 2.8) + 0.126 * u_time);
    
    float f = fbm(uv + r);
    
    // --- НОВАЯ ЦВЕТОВАЯ ПАЛИТРА (БОЛЬШЕ ЧЕРНОГО) ---
    // Глубокий черный (основа)
    vec3 color_black = vec3(0.0, 0.0, 0.0);      
    // Очень темный синий (тени)
    vec3 color_dark  = vec3(0.0, 0.02, 0.1);     
    // Средний синий (основной цвет)
    vec3 color_mid   = vec3(0.0, 0.15, 0.4);     
    // Светлый бирюзовый (только для бликов)
    vec3 color_light = vec3(0.0, 0.6, 0.8);      
    
    // Смешиваем цвета так, чтобы черного было больше
    // Если шум маленький (f < 0.4), то это почти черный
    vec3 final_color = mix(color_black, color_dark, smoothstep(0.0, 0.4, f));
    
    // Если шум средний (0.4 - 0.7), добавляем синий
    final_color = mix(final_color, color_mid, smoothstep(0.4, 0.7, f));
    
    // Если шум высокий (0.7 - 1.0), добавляем светлый блик (но чуть-чуть)
    final_color = mix(final_color, color_light, smoothstep(0.7, 1.0, f) * 0.5);
    
    // Добавляем легкое свечение в центре (опционально, чтобы оживить картинку)
    float vignette = 1.0 - length(v_vTexcoord - 0.5) * 0.5;
    final_color *= vignette;
    
    gl_FragColor = vec4(final_color, 1.0);
}