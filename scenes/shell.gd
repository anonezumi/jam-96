extends Node2D

@export var fall_time = 2.0
@export var shell_height = 1000.0
@export var spin_speed = 1.0

var time_to_impact = fall_time

func _process(delta: float) -> void:
	time_to_impact -= delta
	$Shell.position.y = -shell_height * (time_to_impact / fall_time)
	$Target.rotation += spin_speed * TAU * delta
	if time_to_impact <= 0:
		var explosion = preload("res://scenes/wave.tscn").instantiate()
		$"..".add_child(explosion)
		explosion.global_position = global_position
		queue_free()
