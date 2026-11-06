/// @function scrCameraShakeMenuAnyTextboxFocused
/// @description Проверяет, находится ли фокус в любом Quill-боксе меню.
/// @returns {bool} True, если хотя бы один бокс в фокусе.

function scrCameraShakeMenuAnyTextboxFocused()
{
    for (var i = 0; i < array_length(sliders); i++)
    {
        if (sliders[i].textbox.IsFocused()) return true;
    }
    return false;
}