extends Control

# painstakingly found parameters
const HEX_WIDTH = 60.0
const HALF_WIDTH = HEX_WIDTH / 2.0
const SHORT_EDGE = 17.0
const HEX_HEIGHT = 70.0 - SHORT_EDGE
const SLOPE = SHORT_EDGE / HALF_WIDTH
const VERT_OFFSET = (HEX_HEIGHT - SHORT_EDGE) / 2.0 + SHORT_EDGE
var placeable_tiles = []
@export var towers: Array[PackedScene]
@export var prices: Array[int]
var selected = 0

func _ready() -> void:
	SignalBus.switch_tower.connect(switch_tower)
	for x in range(32):
		placeable_tiles.append([])
		for y in range(20):
			var cell = $"../TileMap".get_cell_tile_data(Vector2(x, y))
			placeable_tiles[x].append(cell.get_custom_data("placeable"))

func switch_tower(index):
	selected = index

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		var coords = get_hex_coords(get_viewport().get_mouse_position())
		if placeable_tiles[coords.x][coords.y]:
			if Global.money >= prices[selected]:
				var tower_inst = towers[selected].instantiate()
				$"..".add_child(tower_inst)
				tower_inst.position = get_center_of_hex(coords)
				placeable_tiles[coords.x][coords.y] = false
				Global.change_money.emit(-prices[selected])

func get_center_of_hex(coords: Vector2i) -> Vector2:
	if coords.y % 2 == 1:
		return Vector2(coords.x * HEX_WIDTH  + HEX_WIDTH,
					   coords.y * HEX_HEIGHT + VERT_OFFSET)
	else:
		return Vector2(coords.x * HEX_WIDTH  + HALF_WIDTH,
					   coords.y * HEX_HEIGHT + VERT_OFFSET)


func get_hex_coords(pos: Vector2) -> Vector2i: # shameless hex grid code from stackoverflow
		var row = floori(pos.y / HEX_HEIGHT)
		var column
		
		# odd rows are offset by a half width
		if row % 2 == 1:
			column = floor((pos.x - HALF_WIDTH) / HEX_WIDTH)
		else:
			column = floor(pos.x / HEX_WIDTH)
		
		# obtain positions relative to the rectangle grid
		var relY = pos.y - (HEX_HEIGHT * row)
		var relX = pos.x - (HEX_WIDTH * column)
		
		# undo what we did
		if row % 2 == 1:
			relX -= HALF_WIDTH
		
		if relY < (-SLOPE * relX) + SHORT_EDGE: # above the left edge
			row -= 1
			if row % 2 == 1:
				column -= 1
		
		if relY < (SLOPE * relX) - SHORT_EDGE: # above the right edge
			row -= 1
			if row % 2 == 0:
				column += 1
		
		return Vector2i(column, row)
