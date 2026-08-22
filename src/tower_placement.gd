extends Control

@export var towers: Array[PackedScene]
@export var prices: Array[int]
@onready var tilemap = $"../TileMap"
var selected = 0
var hovered_tile
var special_cooldown = 10.0
var time_to_special = 0.0

func _ready() -> void:
	SignalBus.switch_tower.connect(switch_tower)

func _process(delta: float) -> void:
	time_to_special -= delta
	queue_redraw()

func _draw():
	var hex = tilemap.HEX_OFFSETS.duplicate()
	hovered_tile = tilemap.tile_at_position(get_viewport().get_mouse_position())
	if hovered_tile == null:
		return
	for i in range(6):
		hex[i] += hovered_tile.center
	draw_colored_polygon(hex, Color.from_rgba8(192, 192, 192, 32))
	if hovered_tile.tower == null:
		return
	draw_circle(hovered_tile.center, hovered_tile.tower.attack_range, Color.from_rgba8(64, 64, 64, 64))

func switch_tower(index):
	selected = index

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			tilemap.place_tower(towers[selected], prices[selected])
		elif (event.button_index == MouseButton.MOUSE_BUTTON_RIGHT
			  and tilemap.possessed_tower != null
			  and time_to_special <= 0):
			tilemap.possessed_tower.shoot_special()
			time_to_special = special_cooldown
