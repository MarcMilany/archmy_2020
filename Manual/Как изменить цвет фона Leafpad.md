Как изменить цвет фона?
Проверьте свой .gtkrc-2.0 (или .gtkrc-2.0.mine) в домашней папке и внесите необходимые изменения. пример

style "default"
{
	GtkTextView::cursor_color	= "#ffffff"
	
	base[NORMAL]	= "#000000"
	base[ACTIVE]	= "#000080"
	base[SELECTED]	= "#808080"
	text[NORMAL]	= "#c0c0c0"
	text[ACTIVE]	= "#c0c0c0"
	text[SELECTED]	= "#000000"
}
class "GtkTextView" style "default"