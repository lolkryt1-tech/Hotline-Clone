// ==========================================
// === СТАРАЯ КАМЕРА (RAW CAMERA OFF) ===
// ==========================================

if (state == CAMSTATES.GAME && !global.settings.raw_camera)
{
    scrCameraGame();
    scrCameraGameUpdate();
}