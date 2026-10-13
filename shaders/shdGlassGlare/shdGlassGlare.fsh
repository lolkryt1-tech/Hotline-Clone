// Fragment Shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_offset; // Передаем сдвиг от камеры

void main()
{
    // 1. Берем оригинальный пиксель окна
    vec4 base_color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    // 2. Генерируем наклонные полосы математикой (по внутренним UV-координатам спрайта)
    float lines = sin((v_vTexcoord.y * 60.0) + (v_vTexcoord.x * 12.0) - u_offset);
    
    // 3. Делаем полосы четкими и выразительными
    float glare = smoothstep(0.7, 0.9, lines);
    
    // 4. Накладываем блик ТОЛЬКО на само стекло (игнорируем прозрачный фон вокруг рамы)
    if (base_color.a > 0.1) {
        base_color.rgb += vec3(glare * 0.6); // Добавляем белый глянец
    }
    
    gl_FragColor = base_color;
}
