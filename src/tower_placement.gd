extends Control

var placeable_tiles = []
@export var towers: Array[PackedScene]
@export var prices: Array[int]
@onready var tilemap = $"../TileMap"
var selected = 0

func _ready() -> void:
	SignalBus.switch_tower.connect(switch_tower)
	for x in range(35):
		placeable_tiles.append([])
		for y in range(24):
			var cell = tilemap.get_cell_tile_data(Vector2(x, y))
			placeable_tiles[x].append(cell.get_custom_data("placeable"))

func switch_tower(index):
	selected = index

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		var coords = tilemap.get_hex_coords(get_viewport().get_mouse_position())
		if placeable_tiles[coords.x][coords.y]:
			if Global.money >= prices[selected]:
				var tower_inst = towers[selected].instantiate()
				$"..".add_child(tower_inst)
				tower_inst.position = tilemap.get_center_of_hex(coords)
				placeable_tiles[coords.x][coords.y] = false
				Global.change_money.emit(-prices[selected])
				SignalBus.tower_placed.emit(coords)
	# elif event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
	#	var dbg_enemy = preload("res://scenes/enemy.tscn").instantiate()
	#	dbg_enemy.dbg = true
	#	dbg_enemy.speed = 0
	#	dbg_enemy.find_child("Health").health = 10000000
	#	dbg_enemy.global_position = get_viewport().get_mouse_position()
	#	$"../Enemies".add_child(dbg_enemy)
