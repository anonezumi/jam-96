extends OptionButton

const WINDOW_MODE_ARRAY: Array[String] = [
	"Full-screen",
	"Windowed",
	"Borderless Windowed",
	"Borderless Fullscreen"
]

func _ready():
	for window_mode in WINDOW_MODE_ARRAY:
		add_item(window_mode)
	# _on_option_button_item_selected(SettingsDataContainer.get_window_mode_index())
	# select(SettingsDataContainer.get_window_mode_index())
	

func _on_option_button_item_selected(index):
	SignalBus.emit(index)
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #Borderless Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
