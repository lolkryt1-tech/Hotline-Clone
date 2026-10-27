// Двигаем синусоиду вперед
anim_time += twinkle_speed;

// Синус от 0 до PI (3.14) дает идеальную дугу: 0 -> 1 -> 0
// Когда anim_time превышает PI, звезда завершила свой цикл (родилась, выросла, погасла)
if (anim_time >= pi) {
    // ПЕРЕД ТЕМ КАК УМЕРЕТЬ, создаем новую звезду на небе через бэкграунд
    if (instance_exists(objScoreBackGround)) {
        var _gui_w = display_get_gui_width();
        var _gui_h = display_get_gui_height();
        var _horizon_y = _gui_h * 0.5;
        
        // Создаем замену в случайной точке неба
        instance_create_layer(random(_gui_w), random(_horizon_y - 15), "Instances", objScoreStar);
    }
    
    // Уничтожаем текущую погасшую звезду
    instance_destroy();
    exit;
}

// Вычисляем плавную волну от 0 до 1 и обратно до 0
var _wave = sin(anim_time);

// Меняем масштаб на основе волны (увеличение - уменьшение)
var _current_scale = lerp(base_scale, max_scale, _wave);
image_xscale = _current_scale;
image_yscale = _current_scale;

// Прозрачность синхронизируем с размером
image_alpha = lerp(0.1, 0.9, _wave);
