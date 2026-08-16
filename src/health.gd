extends Node2D

@export var health: int = 5
@export var money: int = 2

func damage(amt: int):
	health -= amt
	if health <= 0:
		Global.change_money.emit(money)
		$"..".queue_free()
