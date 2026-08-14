extends Control

@onready var my_timer = $Timer

func _ready():
	my_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	visible = false
	SignalBus.splash_done.emit()
	my_timer.stop()

func _on_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
