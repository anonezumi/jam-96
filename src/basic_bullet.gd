extends Node2D

@export var damage = 1.0
@export var lifetime = 5.0

var velocity: Vector2 = Vector2(0, 0)

func _process(delta: float) -> void:
	position += velocity * delta

func set_velocity(vel: Vector2):
	velocity = vel
	rotation = vel.angle()

func _on_hit(body: Node2D) -> void:
	var health = body.find_child("Health")
	if health != null:
		health.damage(damage)
		queue_free()
