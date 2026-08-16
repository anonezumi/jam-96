extends Panel

@export var tower_index = 0


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		SignalBus.switch_tower.emit(tower_index)
