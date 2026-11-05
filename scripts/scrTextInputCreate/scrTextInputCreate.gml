/// @function scrTextInputCreate
/// @description Создаёт структуру состояния текстового поля.
/// @param {string} _text Начальный текст.
/// @returns {struct} Структура текстового поля.

function scrTextInputCreate(_text)
{
    return {
        text: _text,

        cursor: string_length(_text),
		
        selection_start: string_length(_text),
        selection_end: string_length(_text),
		selection_anchor: string_length(_text),

        active: false,
        dragging_selection: false,

        max_length: 256,
        input_type: "text",

        scroll_start: 0,
		scroll_x: 0,
        cursor_blink_time: current_time
    };
}