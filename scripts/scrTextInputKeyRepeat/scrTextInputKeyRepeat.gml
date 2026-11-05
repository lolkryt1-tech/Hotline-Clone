/// @function scrTextInputKeyRepeat
/// @description Обрабатывает первоначальное нажатие и быстрый повтор удерживаемой клавиши.
/// @param {bool} _pressed Первоначальное нажатие.
/// @param {bool} _held Состояние удержания.
/// @param {struct} _timers Структура таймеров повторения.
/// @param {string} _key Имя клавиши.
/// @param {real} _delay Задержка перед началом повтора в миллисекундах.
/// @param {real} _interval Интервал между повторами в миллисекундах.
/// @returns {bool} True, если действие должно выполниться.

function scrTextInputKeyRepeat(_pressed, _held, _timers, _key, _delay, _interval)
{
    // Первоначальное нажатие.
    if (_pressed)
    {
        _timers[$ _key] = current_time + _delay;
        return true;
    }

    // Сброс при отпускании.
    if (!_held)
    {
        _timers[$ _key] = 0;
        return false;
    }

    // Ожидание перед повтором.
    if (current_time < _timers[$ _key])
    {
        return false;
    }

    // Планируем следующий повтор.
    _timers[$ _key] = current_time + _interval;

    return true;
}