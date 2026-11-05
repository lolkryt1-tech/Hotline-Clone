varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec3 u_color_base;
uniform vec3 u_color_glow;
uniform float u_progress;
uniform vec2 u_smoke_seed; 

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

// Модифицированный FBM для более волокнистой структуры клубов
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 5; i++) {
        // Использование модуля (abs) делает шум более похожим на огонь/густые клубы пара
        value += amplitude * abs(noise(st * frequency) - 0.5) * 2.0;
        frequency *= 2.2;
        amplitude *= 0.5;
    }
    return value;
}

void main()
{
    vec2 uv = v_vTexcoord;
    float mask_x = uv.x; 
    float mask_y = uv.y;
    
    // Коррекция соотношения сторон
    uv.x *= u_resolution.x / u_resolution.y;
    
    // Масштабируем UV (3.0 делает вихри чуть мельче и детальнее, убирая сплошные пятна)
    vec2 cloud_uv = (uv * 3.0) + u_smoke_seed;
    
    float time_shift = u_time * 0.6; // Немного замедлили бег дыма для плавности
    
    // Турбулентный сдвиг
    vec2 q = vec2(0.0);
    q.x = fbm(cloud_uv - vec2(time_shift * 0.4, time_shift * 0.1));
    q.y = fbm(cloud_uv - vec2(time_shift * 0.1, -time_shift * 0.3));
    
    // Основной расчет шума
    float f = fbm(cloud_uv - vec2(time_shift * 1.0, time_shift * 0.2) + q * 0.4);
    
    // --- РЕГУЛИРОВКА ПЛОТНОСТИ (Смягчение) ---
    // Вместо жесткого smoothstep делаем мягкий провал. Измените 0.7 для настройки прозрачности просветов.
    float smoke = smoothstep(0.1, 0.7, 1.0 - f);
    
    // Дополнительно ослабляем средние слои, чтобы появились глубокие прозрачные "дыры" в тумане
    smoke = pow(smoke, 1.5); 
    
    // --- Маска высоты (Стелим дым по низу) ---
    // Поднимаем чуть выше (0.35), но делаем переход к прозрачности очень мягким
    float height_mask = smoothstep(0.35, 0.95, mask_y + (f * 0.2));
    
    // --- Линейное заполнение слева направо ---
    float progress_threshold = u_progress * 1.5 - 0.2;
    float appearance_mask = smoothstep(progress_threshold + 0.3, progress_threshold, mask_x);
    
    // Смешивание базового цвета и свечения
    vec3 final_color = mix(u_color_base, u_color_glow, smoke);
    
    // --- ОБЩАЯ ПРОЗРАЧНОСТЬ ---
    // Уменьшили базовый множитель с 0.95 до 0.55, чтобы туман стал полупрозрачным
    float alpha = smoke * height_mask * appearance_mask * 0.55;
    
    gl_FragColor = vec4(final_color, alpha);
}
