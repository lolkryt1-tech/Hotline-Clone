// === ТЕСТОВЫЕ ТЕКСТОВЫЕ ПОЛЯ ===

text_fields = [
    scrTextInputCreate("Hello World"),
    scrTextInputCreate("125.50"),
    scrTextInputCreate("objEnemy")
];

// Настраиваем типы полей.

text_fields[0].input_type = "text";
text_fields[1].input_type = "decimal";
text_fields[2].input_type = "text";

// === РАСПОЛОЖЕНИЕ ===

field_x = 100;
field_y = 120;

field_w = 300;
field_h = 36;
field_gap = 18;

// === СОСТОЯНИЕ ===

active_field = -1;

gui_font = fntDebug;

// === ПОВТОР КЛАВИШ ===

key_repeat_delay = 450;
key_repeat_interval = 40;

//key_repeat_timers = delete backspace: 0,: 0, left: 0, right: 0  };