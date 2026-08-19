extends Node2D

@export var scale_factor: float = 1
@export var damage: int = 5
@export var max_size: float = 6
@onready var particles = $Particles

func _process(delta: float) -> void:
	if scale.x > max_size:
		queue_free()
	scale.x += scale_factor * delta
	scale.y += scale_factor * delta
	particles.emission_ring_radius += scale_factor * delta
	particles.emission_ring_inner_radius += scale_factor * delta

func _on_hit(body: Node2D) -> void:
	var health = body.find_child("Health")
	if health != null:
		health.damage(damage)
