extends Node

var money: int = 100

signal change_money(difference: int)

func _ready() -> void:
	change_money.connect(_change_money)

func _change_money(difference: int):
	money += difference
