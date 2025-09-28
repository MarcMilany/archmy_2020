############ Справка по Pulseaudio ############
# pulseaudio --check  # Проверьте, запущен ли какой-либо экземпляр pulseaudio ; Обычно он не выводит никаких выходных данных, только код выхода. 0 - Это означает, что процесс запущен.
# pulseaudio -k  # Если какой-либо экземпляр запущен, завершите его
# pulseaudio -D  # Наконец, запустите pulseaudio снова как демон
# sudo systemctl --user start pulseaudio
# sudo systemctl --user enable pulseaudio
###############