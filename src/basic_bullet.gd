extends Node2D

@export var pvel_normal_scale = -1.0
@export var pvel_tangent_scale = 0.5
@export var vel_variance = 1.2

var velocity: Vector2 = Vector2(0, 0)

func _process(delta: float) -> void:
	position += velocity

func set_velocity(vel: Vector2):
	velocity = vel
	rotation = vel.angle()
