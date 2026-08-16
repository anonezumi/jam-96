extends Node2D

@export var health: int = 5

func damage(damage: int):
	health -= damage
	if health <= 0:
		$"..".queue_free()
