extends CharacterBody2D

@export var target: Node2D
var speed = 300.0

func _physics_process(delta: float) -> void:
	
	rotation = global_position.angle_to_point(target.global_position)
	velocity = Vector2(speed, 0)
	velocity = velocity.rotated(rotation)

	move_and_slide()
