extends Control

var splash_screen = load("uid://dkq4uxka87wmh")

func _ready() -> void:
	add_child(splash_screen.instantiate())

func _on_play_button_pressed():
	pass # change to game scene

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("uid://ddm0t20wh1el0")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("uid://deh5sabrbl6fy")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
