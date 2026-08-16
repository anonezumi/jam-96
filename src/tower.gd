extends Node2D

@export var cooldown: float = 1.0
@export var shot_speed: float = 5.0
var time_since_fire = cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_fire -= delta
	if time_since_fire <= 0:
		time_since_fire += cooldown
		var bullet_inst = preload("res://scenes/basic_bullet.tscn").instantiate()
		add_child(bullet_inst)
		var vel = Vector2.from_angle(randf() * TAU) * shot_speed
		bullet_inst.set_velocity(vel)
