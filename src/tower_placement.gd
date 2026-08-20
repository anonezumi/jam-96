extends Control

@export var towers: Array[PackedScene]
@export var prices: Array[int]
@onready var tilemap = $"../TileMap"
var selected = 0

func _ready() -> void:
	SignalBus.switch_tower.connect(switch_tower)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw():
	var hex = tilemap.HEX_OFFSETS.duplicate()
	var tile = tilemap.tile_at_position(get_viewport().get_mouse_position())
	if tile == null:
		return
	for i in range(6):
		hex[i] += tile.center
	draw_colored_polygon(hex, Color.from_rgba8(192, 192, 192, 32))

func switch_tower(index):
	selected = index

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		tilemap.place_tower(towers[selected], prices[selected])
