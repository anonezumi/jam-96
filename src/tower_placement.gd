extends Control

@export var towers: Array[PackedScene]
@export var prices: Array[int]
@onready var tilemap = $"../TileMap"
var selected = 0

func _ready() -> void:
	SignalBus.switch_tower.connect(switch_tower)

func switch_tower(index):
	selected = index

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		tilemap.place_tower(towers[selected], prices[selected])
