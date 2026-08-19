extends Node2D

var has_target = false
var target: Vector2
var origin: Vector2
var hit_time: float
var time_elapsed: float = 0.0
const CUBIC = [-1, 3, 1] # no need for a constant term that's dumb
const DIV_FACTOR = CUBIC[0] * 8 + CUBIC[1] * 4 + CUBIC[2] * 2

func _process(delta: float) -> void:
	if not has_target:
		return
	time_elapsed += delta
	if time_elapsed >= hit_time:
		var explosion = preload("res://scenes/wave.tscn").instantiate()
		$"..".add_child(explosion)
		explosion.global_position = global_position
		queue_free()
		return
	var p = 2 * time_elapsed / hit_time
	var lerp_point = (CUBIC[0] * (p**3) + CUBIC[1] * (p*p) + CUBIC[2] * p) / DIV_FACTOR
	global_position = lerp(origin, target, lerp_point)

func set_target(point: Vector2, speed: float):
	has_target = true
	target = point
	origin = global_position
	hit_time = origin.distance_to(point) / speed
