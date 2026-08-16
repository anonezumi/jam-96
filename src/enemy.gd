extends CharacterBody2D

@export var target: Node2D
@export var speed = 300.0

func _physics_process(delta: float) -> void:
	velocity = global_position.direction_to(target.global_position) * speed

	move_and_slide()
