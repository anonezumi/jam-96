extends Node2D

@export var damage = 1.0
@export var lifetime = 5.0

var velocity: Vector2 = Vector2(0, 0)
var timeout = false
var time_to_free = 0.5

func _process(delta: float) -> void:
	if timeout:
		time_to_free -= delta
		if time_to_free <= 0:
			queue_free()
	else:
		position += velocity * delta
		lifetime -= delta
		if lifetime <= 0:
			timeout = true
			$Particles.emitting = false

func set_velocity(vel: Vector2):
	velocity = vel
	rotation = vel.angle()

func _on_hit(body: Node2D) -> void:
	var health = body.find_child("Health")
	if health != null and not timeout:
		health.damage(damage)
		timeout = true
		$Particles.emitting = false
