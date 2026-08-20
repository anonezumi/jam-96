extends Node2D

@export var scale_factor: float = 1
@export var damage: int = 5
@export var max_size: float = 6
@onready var particles = $Particles

var timeout = false
var time_to_free = 0.5

func _process(delta: float) -> void:
	if scale.x > max_size:
		timeout = true
		particles.emitting = false
	if timeout:
		time_to_free -= delta
		if time_to_free <= 0:
			queue_free()
		return
	scale.x += scale_factor * delta
	scale.y += scale_factor * delta
	particles.emission_ring_radius += scale_factor * delta
	particles.emission_ring_inner_radius += scale_factor * delta

func _on_hit(body: Node2D) -> void:
	var health = body.find_child("Health")
	if health != null and not timeout:
		health.damage(damage)
